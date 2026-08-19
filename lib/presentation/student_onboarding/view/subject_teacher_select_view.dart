import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/section_progress_indicator.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';
import '../widgets/subject_row.dart';

/// Step 3/3 of student onboarding — a multi-select of subjects (scoped to
/// the board/class chosen in step 2), where each selected subject can
/// optionally get a teacher assigned from the campus (chosen in step 1)
/// teacher directory.
class SubjectTeacherSelectView extends ConsumerWidget {
  const SubjectTeacherSelectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(studentOnboardingViewModelProvider.notifier);
    final boardClassId = notifier.boardClassId;
    final campusId = notifier.campusId;

    ref.listen(studentOnboardingViewModelProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        AppSnackbar.show(
          context,
          error is Failure ? error.message : context.l10n.commonErrorGeneric,
        );
      }
    });

    if (boardClassId == null || campusId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.subjectTeacherSelectTitle)),
        body: EmptyStateView(
          message: context.l10n.subjectTeacherSelectPrerequisites,
        ),
      );
    }

    final subjectsAsync = ref.watch(subjectsForBoardClassProvider(boardClassId));
    final teachersAsync = ref.watch(teachersForCampusProvider(campusId));
    final isSubmitting = ref.watch(
      studentOnboardingViewModelProvider.select((s) => s.isLoading),
    );

    final selectedSubjectIds = notifier.selectedSubjectIds;
    final teacherBySubject = notifier.teacherIdBySubjectId;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.subjectTeacherSelectTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionProgressIndicator(currentStep: 2, totalSteps: 3),
              SizedBox(height: context.dimens.lg),
              Text(
                context.l10n.subjectTeacherSelectSubtitle,
                style: context.textStyles.titleMedium,
              ),
              SizedBox(height: context.dimens.lg),
              Expanded(
                child: AsyncValueWidget<List<Subject>>(
                  value: subjectsAsync,
                  onRetry: () =>
                      ref.invalidate(subjectsForBoardClassProvider(boardClassId)),
                  data: (subjects) {
                    if (subjects.isEmpty) {
                      return EmptyStateView(
                        message: context.l10n.subjectTeacherSelectNoSubjects,
                      );
                    }
                    final teachers = teachersAsync.value ?? const <TeacherOption>[];
                    return ListView.separated(
                      itemCount: subjects.length,
                      separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        final isSelected = selectedSubjectIds.contains(subject.id);
                        final teachersForSubject = teachers
                            .where((t) => t.subjectIds.contains(subject.id))
                            .toList();
                        final assignedTeacherId = teacherBySubject[subject.id];
                        final assignedTeacher = assignedTeacherId == null
                            ? null
                            : teachersForSubject
                                .where((t) => t.id == assignedTeacherId)
                                .firstOrNull;

                        return SubjectRow(
                          subjectName: subject.name,
                          isSelected: isSelected,
                          onSelectedChanged: (_) =>
                              notifier.toggleSubject(subject.id),
                          teacherPicker: !isSelected
                              ? null
                              : teachersForSubject.isEmpty
                                  ? Text(
                                      context.l10n.subjectTeacherSelectNoTeachers,
                                      style: context.textStyles.bodySmall?.copyWith(
                                        color: context.colors.textSecondary,
                                      ),
                                    )
                                  : AppDropdown<TeacherOption>(
                                      label: context.l10n.subjectTeacherSelectTeacherLabel,
                                      items: teachersForSubject,
                                      selectedItem: assignedTeacher,
                                      itemAsString: (t) => t.name,
                                      onChanged: (teacher) => notifier.assignTeacher(
                                        subject.id,
                                        teacher?.id,
                                      ),
                                    ),
                          discountApplied: assignedTeacherId != null,
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: context.dimens.lg),
              AppPrimaryButton(
                label: context.l10n.commonConfirm,
                loading: isSubmitting,
                onPressed: selectedSubjectIds.isEmpty || isSubmitting
                    ? null
                    : notifier.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
