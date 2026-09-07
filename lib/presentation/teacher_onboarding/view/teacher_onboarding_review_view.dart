import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../core/widgets/onboarding_summary_item.dart';
import '../../../domain/common/failure.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../auth/widgets/onboarding_logout_action.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../viewmodel/teacher_signup_form_providers.dart';
import '../viewmodel/teacher_signup_form_state.dart';

/// Final teacher onboarding step — shows everything collected across the
/// self-signup form's two steps for the teacher to double-check before a
/// "Submit" finalizes registration. Name/campus are read-only here (like
/// every other field on this screen) — to fix a typo the teacher goes Back
/// to step 1, which now correctly preserves what they'd already typed.
class TeacherOnboardingReviewView extends ConsumerWidget {
  const TeacherOnboardingReviewView({super.key});

  String _classIdsKey(Set<String> classIds) {
    final sorted = classIds.toList()..sort();
    return sorted.join(',');
  }

  void _handleSubmit(
    BuildContext context,
    WidgetRef ref,
    TeacherFormState formState,
  ) {
    final campus = formState.campus;
    if (campus == null) return;
    ref
        .read(teacherOnboardingViewModelProvider.notifier)
        .submitSignUp(
          name: formState.name.trim(),
          campusId: campus.id,
          subjectIds: formState.selectedSubjectIds.toList(),
          classIds: formState.selectedClassIds.isEmpty
              ? null
              : formState.selectedClassIds.toList(),
          declaredStudentCount:
              formState.studentCount > 0 ? formState.studentCount : null,
        )
        .then((success) {
      if (!context.mounted || success) return;
      final failure = ref.read(teacherOnboardingViewModelProvider).error;
      AppSnackbar.show(
        context,
        failure is Failure ? failure.message : context.l10n.commonErrorGeneric,
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(teacherFormNotifierProvider);
    final phoneNumber = ref.watch(currentUserProvider)?.phoneNumber ?? '';
    final isSubmitting = ref.watch(
      teacherOnboardingViewModelProvider.select((s) => s.isLoading),
    );
    final boardClassesAsync = ref.watch(teacherSignupBoardClassesProvider);
    final subjectsAsync = ref.watch(
      teacherSignupSubjectsForClassesProvider(
        _classIdsKey(formState.selectedClassIds),
      ),
    );

    final classNames = boardClassesAsync.value
            ?.where((c) => formState.selectedClassIds.contains(c.id))
            .map((c) => c.name)
            .toSet()
            .toList() ??
        const <String>[];
    final subjectNames = subjectsAsync.value
            ?.where(
              (s) => s.subjectIds.any(formState.selectedSubjectIds.contains),
            )
            .map((s) => s.name)
            .toList() ??
        const <String>[];
    final campus = formState.campus;

    return OnboardingScaffold(
      appBarTitle: context.l10n.onboardingReviewTitle,
      role: OnboardingRole.teacher,
      currentStep: 3,
      totalSteps: 3,
      onBack: () => Navigator.of(context).pop(),
      onLogout: () => confirmOnboardingLogout(context, ref),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.onboardingReviewHeadline,
            subtitle: context.l10n.onboardingReviewSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          OnboardingSummaryList(
            children: [
              OnboardingSummaryItem(
                icon: Icons.person_rounded,
                label: context.l10n.nameLabel,
                value: formState.name,
              ),
              OnboardingSummaryItem(
                icon: Icons.location_city_rounded,
                label: context.l10n.campusLabel,
                value: campus == null ? '' : '${campus.name} — ${campus.city}',
              ),
              OnboardingSummaryItem(
                icon: Icons.phone_rounded,
                label: context.l10n.phoneLabel,
                value: phoneNumber,
              ),
              OnboardingSummaryItem(
                icon: Icons.groups_rounded,
                label: context.l10n.teacherSignupApproxStudentsLabel,
                value: formState.studentCount > 0
                    ? context.l10n.teacherSignupSummaryStudentsCount(
                        formState.studentCount,
                      )
                    : context.l10n.teacherSignupSummaryNotSpecified,
                isMuted: formState.studentCount <= 0,
              ),
              OnboardingSummaryChipSection(
                icon: Icons.class_rounded,
                label: context.l10n.teacherSignupClassesLabel,
                items: classNames,
              ),
              OnboardingSummaryChipSection(
                icon: Icons.menu_book_rounded,
                label: context.l10n.teacherSignupSubjectsLabel,
                items: subjectNames,
              ),
            ],
          ),
          SizedBox(height: context.dimens.xl),
          AppPrimaryButton(
            label: context.l10n.commonSubmit,
            loading: isSubmitting,
            onPressed: () => _handleSubmit(context, ref, formState),
          ),
        ],
      ),
    );
  }
}
