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
import '../../../domain/common/failure.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../viewmodel/student_profile_viewmodel.dart';
import '../widgets/language_card.dart';

/// Student shell Profile tab root (§10.2: "Edit profile, language toggle,
/// delete account"). One primary action per §10.1: the "Save" `AppPrimaryButton`;
/// "Delete account" is a de-emphasized `AppDangerButton` behind a confirmation dialog.
class StudentProfileView extends ConsumerStatefulWidget {
  const StudentProfileView({super.key});

  @override
  ConsumerState<StudentProfileView> createState() =>
      _StudentProfileViewState();
}

class _StudentProfileViewState extends ConsumerState<StudentProfileView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _syncedStudentId;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllers(Student student) {
    if (_syncedStudentId == student.id) return;
    _nameController.text = student.name;
    _phoneController.text = student.phoneNumber;
    _syncedStudentId = student.id;
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    if (name.isEmpty || phoneNumber.isEmpty) {
      AppSnackbar.show(context, context.l10n.profileEmptyFields);
      return;
    }

    ref
        .read(studentProfileViewModelProvider.notifier)
        .updateProfile(name: name, phoneNumber: phoneNumber)
        .then((ok) {
      if (!mounted) return;
      if (ok) {
        AppSnackbar.show(context, context.l10n.profileUpdatedSuccess);
      } else {
        final error = ref.read(studentProfileViewModelProvider).error;
        final msg = error is Failure ? error.message : context.l10n.profileUpdateFailed;
        AppSnackbar.show(context, msg);
      }
    });
  }

  void _handleDeleteAccount() {
    confirmDialog(
      context,
      title: context.l10n.profileDeleteDialogTitle,
      message: context.l10n.profileDeleteDialogBody,
      confirmLabel: context.l10n.profileDeleteAccount,
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed != true || !mounted) return;
      ref
          .read(studentProfileViewModelProvider.notifier)
          .deleteAccount()
          .then((ok) {
        if (!mounted) return;
        if (!ok) {
          final error = ref.read(studentProfileViewModelProvider).error;
          final msg = error is Failure ? error.message : context.l10n.profileDeleteFailed;
          AppSnackbar.show(context, msg);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(
      studentOnboardingViewModelProvider.select((s) => s.value),
    );
    final isSaving = ref.watch(
      studentProfileViewModelProvider.select((s) => s.isLoading),
    );
    final isEnglish = ref.watch(
      localeProvider.select((l) => l == null || l.languageCode == 'en'),
    );

    if (student != null) {
      _syncControllers(student);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profileTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.studentHome);
            }
          },
        ),
      ),
      body: SafeArea(
        child: student == null
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
                    StudentLanguageCard(isEnglish: isEnglish),
                    SizedBox(height: context.dimens.xxl),
                    Center(
                      child: AppDangerButton(
                        label: context.l10n.profileDeleteAccount,
                        icon: Icons.delete_outline,
                        onPressed: isSaving ? null : _handleDeleteAccount,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
