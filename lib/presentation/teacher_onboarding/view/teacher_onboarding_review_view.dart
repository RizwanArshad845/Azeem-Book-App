import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../core/widgets/onboarding_summary_item.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/common/failure.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../viewmodel/teacher_signup_form_providers.dart';
import '../viewmodel/teacher_signup_form_state.dart';

/// Final teacher onboarding step — shows everything collected across the
/// self-signup form's two steps for the teacher to double-check (and fix a
/// typo in their name or campus) before a "Submit" finalizes registration.
class TeacherOnboardingReviewView extends ConsumerStatefulWidget {
  const TeacherOnboardingReviewView({super.key});

  @override
  ConsumerState<TeacherOnboardingReviewView> createState() =>
      _TeacherOnboardingReviewViewState();
}

class _TeacherOnboardingReviewViewState
    extends ConsumerState<TeacherOnboardingReviewView> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(teacherFormNotifierProvider).name,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final formState = ref.watch(teacherFormNotifierProvider);
    final notifier = ref.read(teacherFormNotifierProvider.notifier);
    final phoneNumber = ref.watch(currentUserProvider)?.phoneNumber ?? '';
    final isSubmitting = ref.watch(
      teacherOnboardingViewModelProvider.select((s) => s.isLoading),
    );
    final campusesAsync = ref.watch(teacherSignupCampusesProvider);
    final boardClassesAsync = ref.watch(teacherSignupBoardClassesProvider);
    final subjectsAsync = ref.watch(
      teacherSignupSubjectsForClassesProvider(
        _classIdsKey(formState.selectedClassIds),
      ),
    );

    final classNames = boardClassesAsync.value
            ?.where((c) => formState.selectedClassIds.contains(c.id))
            .map((c) => c.name)
            .toList() ??
        const <String>[];
    final subjectNames = subjectsAsync.value
            ?.where((s) => formState.selectedSubjectIds.contains(s.id))
            .map((s) => s.name)
            .toList() ??
        const <String>[];

    return OnboardingScaffold(
      appBarTitle: context.l10n.onboardingReviewTitle,
      role: OnboardingRole.teacher,
      currentStep: 3,
      totalSteps: 3,
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.onboardingReviewHeadline,
            subtitle: context.l10n.onboardingReviewSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          AppTextField(
            label: context.l10n.nameLabel,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            isRequired: true,
            onChanged: notifier.updateName,
          ),
          SizedBox(height: context.dimens.lg),
          AppDropdownCard<Campus>(
            label: context.l10n.campusLabel,
            items: campusesAsync.value ?? const <Campus>[],
            selectedItem: formState.campus,
            isRequired: true,
            icon: Icons.location_city_rounded,
            itemAsString: (c) => '${c.name} (${c.city})',
            onChanged: notifier.updateCampus,
          ),
          SizedBox(height: context.dimens.lg),
          OnboardingSummaryList(
            children: [
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
