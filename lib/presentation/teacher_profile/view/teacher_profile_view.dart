import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/typed_confirm.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../viewmodel/teacher_profile_viewmodel.dart';
import '../widgets/language_card.dart';

/// Teacher shell Profile tab root (§10.2 lists "Edit profile, language
/// toggle" for the teacher row). One primary action per §10.1: the "Save"
/// `AppPrimaryButton`; "Delete account" is a de-emphasized `AppDangerButton`
/// behind a confirmation dialog.
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

  void _handleSave() {
    final name = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    if (name.isEmpty || phoneNumber.isEmpty) {
      AppSnackbar.show(context, context.l10n.profileEmptyFields);
      return;
    }

    ref
        .read(teacherProfileViewModelProvider.notifier)
        .updateProfile(name: name, phoneNumber: phoneNumber)
        .then((ok) {
      if (!mounted) return;
      if (ok) {
        AppSnackbar.show(context, context.l10n.profileUpdatedSuccess);
      } else {
        final error = ref.read(teacherProfileViewModelProvider).error;
        final msg = error is Failure ? error.message : context.l10n.profileUpdateFailed;
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
    ).then((confirmed) {
      if (confirmed != true || !mounted) return;
      ref
          .read(teacherProfileViewModelProvider.notifier)
          .deleteAccount()
          .then((ok) {
        if (!mounted) return;
        if (!ok) {
          final error = ref.read(teacherProfileViewModelProvider).error;
          final msg = error is Failure ? error.message : context.l10n.profileDeleteFailed;
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
                    ),
                    SizedBox(height: context.dimens.lg),
                    AppPrimaryButton(
                      label: context.l10n.commonSave,
                      loading: isSaving,
                      onPressed: _handleSave,
                    ),
                    SizedBox(height: context.dimens.xxl),
                    TeacherLanguageCard(isEnglish: isEnglish),
                    SizedBox(height: context.dimens.lg),
                    AppOutlinedButton(
                      label: context.l10n.profileLogout,
                      icon: Icons.logout,
                      onPressed: isSaving ? null : _handleLogout,
                    ),
                    SizedBox(height: context.dimens.xxl),
                    Center(
                      child: AppDangerButton(
                        label: context.l10n.profileDeleteAccount,
                        icon: Icons.delete_outline,
                        onPressed: isSaving ? null : () => _handleDeleteAccount(teacher),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
