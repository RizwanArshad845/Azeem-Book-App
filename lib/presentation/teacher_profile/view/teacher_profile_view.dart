import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/name_initials.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/typed_confirm.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart';
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
    final phoneNumber = _phoneController.text.trim();
    if (name.isEmpty || phoneNumber.isEmpty) {
      AppSnackbar.show(context, context.l10n.profileEmptyFields);
      return;
    }

    if (!Validators.isValidPhoneLocal(phoneNumber)) {
      AppSnackbar.show(context, context.l10n.phoneInvalid);
      return;
    }

    // If phone number changed, require OTP verification sheet first
    if (phoneNumber != currentTeacher.phoneNumber) {
      _showPhoneOtpVerificationSheet(
        newPhone: phoneNumber,
        onVerified: () => _commitUpdate(name: name, phoneNumber: phoneNumber),
      );
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

  void _showPhoneOtpVerificationSheet({
    required String newPhone,
    required VoidCallback onVerified,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _PhoneOtpVerificationSheet(
        newPhone: newPhone,
        onVerified: onVerified,
      ),
    );
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

    final campusesById =
        ref.watch(teacherStudentsCampusesByIdProvider).value ??
        const <String, Campus>{};
    final subjectsById =
        ref.watch(teacherStudentsSubjectsByIdProvider).value ??
        const <String, Subject>{};

    if (teacher != null) {
      _syncControllers(teacher);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profileTitle),
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
                    // 1. Enriched Verified Faculty Card
                    AppFrostedCard(
                      padding: EdgeInsets.all(context.dimens.lg),
                      child: Column(
                        children: [
                          Container(
                            width: context.dimens.avatarLg,
                            height: context.dimens.avatarLg,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.colors.primary,
                                  context.colors.secondary,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              nameInitials(teacher.name),
                              style: context.textStyles.headlineSmall?.copyWith(
                                color: context.colors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: context.dimens.sm),
                          Text(
                            teacher.name,
                            style: context.textStyles.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.dimens.xs / 3),
                          Text(
                            teacher.phoneNumber,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          SizedBox(height: context.dimens.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dimens.md,
                              vertical: context.dimens.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.success
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                context.dimens.radiusLg,
                              ),
                              border: Border.all(
                                color: context.colors.success
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: context.colors.success,
                                  size: context.dimens.iconSm,
                                ),
                                SizedBox(width: context.dimens.xs),
                                Text(
                                  context.l10n.teacherVerifiedBadge,
                                  style: context.textStyles.labelSmall?.copyWith(
                                    color: context.colors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),

                    // 2. Teaching Scope & Credentials Card
                    AppFrostedCard(
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
                                  label:
                                      context.l10n.teacherDefaultCampusFallback,
                                  icon: Icons.account_balance_outlined,
                                ),
                            ],
                          ),
                          if (teacher.classes != null &&
                              teacher.classes!.isNotEmpty) ...[
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
                                for (final className in teacher.classes!)
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
                              for (final subjectId in teacher.subjects)
                                _BadgeChip(
                                  label: subjectsById[subjectId]?.name ??
                                      subjectId,
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
                    ),
                    SizedBox(height: context.dimens.lg),

                    // 3. Edit Personal Information Card
                    AppFrostedCard(
                      padding: EdgeInsets.all(context.dimens.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Personal Information',
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

/// Self-contained modal bottom sheet for verifying new phone numbers via OTP.
class _PhoneOtpVerificationSheet extends ConsumerStatefulWidget {
  const _PhoneOtpVerificationSheet({
    required this.newPhone,
    required this.onVerified,
  });

  final String newPhone;
  final VoidCallback onVerified;

  @override
  ConsumerState<_PhoneOtpVerificationSheet> createState() =>
      _PhoneOtpVerificationSheetState();
}

class _PhoneOtpVerificationSheetState
    extends ConsumerState<_PhoneOtpVerificationSheet> {
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      AppSnackbar.show(context, context.l10n.teacherOtpEnterCodeError);
      return;
    }

    final isValid = ref
        .read(teacherProfileViewModelProvider.notifier)
        .verifyPhoneChangeOtp(otp);

    if (isValid) {
      Navigator.pop(context);
      widget.onVerified();
    } else {
      AppSnackbar.show(context, context.l10n.teacherOtpInvalidCodeError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AppFrostedCard(
        padding: EdgeInsets.all(context.dimens.lg),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimens.radiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.teacherVerifyNewPhoneTitle,
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: context.dimens.xs),
            Text(
              context.l10n.teacherVerifyPhoneOtpSentMessage(widget.newPhone),
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimens.md),
            AppTextField(
              label: context.l10n.teacherOtpCodeLabel,
              hint: context.l10n.teacherOtpTestHint,
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            SizedBox(height: context.dimens.md),
            AppPrimaryButton(
              label: context.l10n.otpVerifyButton,
              onPressed: _handleVerify,
            ),
            SizedBox(height: context.dimens.sm),
          ],
        ),
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
    return Container(
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
          Icon(icon, size: context.dimens.iconSm, color: context.colors.primary),
          SizedBox(width: context.dimens.xs / 2),
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
