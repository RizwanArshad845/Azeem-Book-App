import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/profile_header_card.dart';
import '../../../core/widgets/typed_confirm.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/class_level.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart'
    show teacherStudentsCampusesByIdProvider;
import '../viewmodel/teacher_profile_catalog_providers.dart';
import '../viewmodel/teacher_profile_viewmodel.dart';
import '../widgets/language_card.dart';

/// Enriched Teacher Profile & Account Settings view featuring verified faculty credentials,
/// teaching scope chips, phone number edit with OTP confirmation sheet, and account deletion.
class TeacherProfileView extends ConsumerStatefulWidget {
  const TeacherProfileView({super.key});

  @override
  ConsumerState<TeacherProfileView> createState() =>
      _TeacherProfileViewState();
}

class _TeacherProfileViewState extends ConsumerState<TeacherProfileView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _syncedTeacherId;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllers(Teacher teacher) {
    if (_syncedTeacherId == teacher.id) return;
    _nameController.text = teacher.name;
    _phoneController.text = teacher.phoneNumber;
    _syncedTeacherId = teacher.id;
  }

  void _handleSave(Teacher currentTeacher) {
    final name = _nameController.text.trim();
    final phoneNumber = currentTeacher.phoneNumber;
    if (name.isEmpty) {
      AppSnackbar.show(context, context.l10n.profileEmptyFields);
      return;
    }

    _commitUpdate(name: name, phoneNumber: phoneNumber);
  }

  void _commitUpdate({required String name, required String phoneNumber}) {
    ref
        .read(teacherProfileViewModelProvider.notifier)
        .updateProfile(name: name, phoneNumber: phoneNumber)
        .then((ok) {
      if (!mounted) return;
      if (ok) {
        AppSnackbar.show(context, context.l10n.profileUpdatedSuccess);
      } else {
        final error = ref.read(teacherProfileViewModelProvider).error;
        final msg =
            error is Failure ? error.message : context.l10n.profileUpdateFailed;
        AppSnackbar.show(context, msg);
      }
    });
  }

  void _handleLogout() {
    confirmDialog(
      context,
      title: context.l10n.profileLogoutConfirmTitle,
      message: context.l10n.profileLogoutConfirmMessage,
      confirmLabel: context.l10n.profileLogout,
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed != true || !mounted) return;
      // Fire-and-forget: setting the session to null drives the router
      // redirect to the auth flow (no manual navigation from here).
      ref.read(authViewModelProvider.notifier).logout();
    });
  }

  void _handleDeleteAccount(Teacher teacher) {
    showTypedConfirmDialog(
      context,
      title: context.l10n.profileDeleteDialogTitle,
      message: context.l10n.profileDeleteDialogBody,
      confirmationText: teacher.phoneNumber,
      fieldLabel: context.l10n.profileDeleteConfirmField(teacher.phoneNumber),
      confirmLabel: context.l10n.profileDeleteAccount,
      cancelLabel: context.l10n.commonCancel,
      maxLength: 11,
      keyboardType: TextInputType.phone,
    ).then((confirmed) {
      if (confirmed != true || !mounted) return;
      ref
          .read(teacherProfileViewModelProvider.notifier)
          .deleteAccount()
          .then((ok) {
        if (!mounted) return;
        if (!ok) {
          final error = ref.read(teacherProfileViewModelProvider).error;
          final msg = error is Failure
              ? error.message
              : context.l10n.profileDeleteFailed;
          AppSnackbar.show(context, msg);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacher = ref.watch(
      teacherOnboardingViewModelProvider.select((s) => s.value),
    );
    final isSaving = ref.watch(
      teacherProfileViewModelProvider.select((s) => s.isLoading),
    );
    final isEnglish = ref.watch(
      localeProvider.select((l) => l == null || l.languageCode == 'en'),
    );

    if (teacher != null) {
      _syncControllers(teacher);
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(context.l10n.profileTitle),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.teacherOverview);
            }
          },
        ),
      ),
      body: SafeArea(
        child: teacher == null
            ? const LoadingIndicator()
            : SingleChildScrollView(
                padding: EdgeInsets.all(context.dimens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Verified Faculty Header Card
                    ProfileHeaderCard(
                      name: teacher.name,
                      phoneNumber: teacher.phoneNumber,
                      badgeLabel: context.l10n.teacherVerifiedBadge,
                    ),
                    SizedBox(height: context.dimens.lg),

                    // 2. Teaching Scope & Credentials Card
                    _TeachingScopeCard(teacher: teacher),
                    SizedBox(height: context.dimens.lg),

                    // 3. Edit Personal Information Card
                    AppFrostedCard(
                      padding: EdgeInsets.all(context.dimens.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.l10n.personalInfoTitle,
                            style: context.textStyles.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.dimens.md),
                          AppTextField(
                            label: context.l10n.nameLabel,
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                          ),
                          SizedBox(height: context.dimens.md),
                          AppTextField(
                            label: context.l10n.phoneLabel,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            enabled: false,
                          ),
                          SizedBox(height: context.dimens.lg),
                          AppPrimaryButton(
                            label: context.l10n.commonSave,
                            loading: isSaving,
                            onPressed: () => _handleSave(teacher),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),

                    // 4. Language Selector Card
                    TeacherLanguageCard(isEnglish: isEnglish),
                    SizedBox(height: context.dimens.lg),

                    // 5. Logout Button
                    AppOutlinedButton(
                      label: context.l10n.profileLogout,
                      icon: Icons.logout,
                      onPressed: isSaving ? null : _handleLogout,
                    ),
                    SizedBox(height: context.dimens.xl),

                    // 6. Delete Account Destructive Action
                    Center(
                      child: AppDangerButton(
                        label: context.l10n.profileDeleteAccount,
                        icon: Icons.delete_outline,
                        onPressed: isSaving
                            ? null
                            : () => _handleDeleteAccount(teacher),
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Teaching scope & credentials card (campuses/classes/subjects/declared
/// reach). Watches the 4 catalog lookups itself so a catalog refetch only
/// rebuilds this card, not the whole profile page.
class _TeachingScopeCard extends ConsumerWidget {
  const _TeachingScopeCard({required this.teacher});

  final Teacher teacher;

  static String _resolveClassName(
    String classId,
    Map<String, BoardClass> boardClassesById,
    Map<String, ClassLevel> classLevelsById,
  ) {
    final boardClass = boardClassesById[classId];
    if (boardClass != null) {
      return boardClass.name;
    }
    final classLevel = classLevelsById[classId];
    if (classLevel != null) {
      return classLevel.name;
    }
    return classId;
  }

  static String _resolveSubjectName(
    String subjectId,
    Map<String, Subject> subjectsById,
    BuildContext context,
  ) {
    final subject = subjectsById[subjectId];
    if (subject != null) {
      return context.l10n.localizedSubjectName(subject.name);
    }
    final localized = context.l10n.localizedSubjectName(subjectId);
    if (localized != subjectId) {
      return localized;
    }
    final lower = subjectId.toLowerCase();
    if (lower.contains('phy')) return context.l10n.subjectPhysics;
    if (lower.contains('chem')) return context.l10n.subjectChemistry;
    if (lower.contains('bio')) return context.l10n.subjectBiology;
    if (lower.contains('math')) return context.l10n.subjectMathematics;
    if (lower.contains('cs') || lower.contains('comp')) {
      return context.l10n.subjectComputerScience;
    }
    if (lower.contains('eng')) return context.l10n.subjectEnglish;
    if (lower.contains('urd')) return context.l10n.subjectUrdu;
    if (lower.contains('sci')) return context.l10n.subjectScience;
    if (lower.contains('acc')) return context.l10n.subjectAccounting;
    if (lower.contains('econ')) return context.l10n.subjectEconomics;
    if (lower.contains('civ')) return context.l10n.subjectCivics;
    if (lower.contains('edu')) return context.l10n.subjectEducation;
    return subjectId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campusesById = ref.watch(
      teacherStudentsCampusesByIdProvider.select(
        (async) => async.value ?? const <String, Campus>{},
      ),
    );
    final boardClassesById = ref.watch(
      teacherProfileBoardClassesByIdProvider.select(
        (async) => async.value ?? const <String, BoardClass>{},
      ),
    );
    final classLevelsById = ref.watch(
      teacherProfileClassLevelsByIdProvider.select(
        (async) => async.value ?? const <String, ClassLevel>{},
      ),
    );
    final subjectsById = ref.watch(
      teacherProfileResolvedSubjectsProvider.select(
        (async) => async.value ?? const <String, Subject>{},
      ),
    );

    return AppFrostedCard(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.teacherProfileCampusesTaught,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.dimens.xs),
          Wrap(
            spacing: context.dimens.xs,
            runSpacing: context.dimens.xs / 2,
            children: [
              if (campusesById.containsKey(teacher.campusId))
                _BadgeChip(
                  label: campusesById[teacher.campusId]!.name,
                  icon: Icons.account_balance_outlined,
                )
              else
                _BadgeChip(
                  label: context.l10n.teacherDefaultCampusFallback,
                  icon: Icons.account_balance_outlined,
                ),
            ],
          ),
          if (teacher.classIds != null && teacher.classIds!.isNotEmpty) ...[
            SizedBox(height: context.dimens.md),
            Text(
              context.l10n.teacherProfileClassesTaught,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.dimens.xs),
            Wrap(
              spacing: context.dimens.xs,
              runSpacing: context.dimens.xs / 2,
              children: [
                for (final className in teacher.classIds!
                    .map((id) => _resolveClassName(
                          id,
                          boardClassesById,
                          classLevelsById,
                        ))
                    .toSet())
                  _BadgeChip(
                    label: className,
                    icon: Icons.school_outlined,
                  ),
              ],
            ),
          ],
          SizedBox(height: context.dimens.md),
          Text(
            context.l10n.teacherProfileSubjectsTaught,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.dimens.xs),
          Wrap(
            spacing: context.dimens.xs,
            runSpacing: context.dimens.xs / 2,
            children: [
              for (final subjectName in teacher.subjectIds
                  .map((id) => _resolveSubjectName(
                        id,
                        subjectsById,
                        context,
                      ))
                  .toSet())
                _BadgeChip(
                  label: subjectName,
                  icon: Icons.menu_book_outlined,
                ),
            ],
          ),
          SizedBox(height: context.dimens.md),
          Text(
            context.l10n.teacherProfileDeclaredReach,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.dimens.xs),
          _BadgeChip(
            label: context.l10n.teacherStudentsEnrolledCount(
              teacher.declaredStudentCount ?? 50,
            ),
            icon: Icons.groups_outlined,
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimens.sm,
          vertical: context.dimens.xs / 2,
        ),
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(context.dimens.radiusSm),
          border: Border.all(
            color: context.colors.divider.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.dimens.iconSm,
              color: context.colors.primary,
            ),
            SizedBox(width: context.dimens.xs / 2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
