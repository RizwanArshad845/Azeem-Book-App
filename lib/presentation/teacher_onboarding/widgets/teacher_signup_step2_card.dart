import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/subject.dart';
import 'multi_select_chip_field.dart';
import 'teacher_section_header.dart';

/// Step 2 Card stateless component for Teacher Onboarding (Classes & Subjects Selection).
class TeacherSignupStep2Card extends StatelessWidget {
  const TeacherSignupStep2Card({
    super.key,
    required this.selectedClassIds,
    required this.selectedSubjectIds,
    required this.boardClassesAsync,
    required this.subjectsAsync,
    required this.classesError,
    required this.subjectsError,
    required this.isSubmitting,
    required this.onClassesChanged,
    required this.onSubjectsChanged,
    required this.onBack,
    required this.onSubmit,
    required this.onRetryBoardClasses,
    required this.onRetrySubjects,
  });

  final Set<String> selectedClassIds;
  final Set<String> selectedSubjectIds;
  final AsyncValue<List<BoardClass>> boardClassesAsync;
  final AsyncValue<List<Subject>> subjectsAsync;
  final String? classesError;
  final String? subjectsError;
  final bool isSubmitting;
  final ValueChanged<Set<String>> onClassesChanged;
  final ValueChanged<Set<String>> onSubjectsChanged;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final VoidCallback onRetryBoardClasses;
  final VoidCallback onRetrySubjects;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TeacherSectionHeader(
          icon: Icons.menu_book_outlined,
          title: context.l10n.teacherSignupWhatYouTeachSection,
          subtitle: context.l10n.boardClassSelectSubtitle,
        ),
        SizedBox(height: context.dimens.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AsyncValueWidget<List<BoardClass>>(
                value: boardClassesAsync,
                onRetry: onRetryBoardClasses,
                data: (boardClasses) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectChipField<BoardClass>(
                      label: context.l10n.teacherSignupClassesLabel,
                      isRequired: true,
                      options: boardClasses,
                      optionLabel: (b) => b.name,
                      optionId: (b) => b.id,
                      selectedIds: selectedClassIds,
                      onChanged: onClassesChanged,
                      emptyMessage: context.l10n.teacherSignupClassesEmpty,
                    ),
                    if (classesError != null) ...[
                      SizedBox(height: context.dimens.xs),
                      Text(
                        classesError!,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: context.dimens.lg),
              AsyncValueWidget<List<Subject>>(
                value: subjectsAsync,
                onRetry: onRetrySubjects,
                data: (subjects) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectChipField<Subject>(
                      label: context.l10n.teacherSignupSubjectsLabel,
                      isRequired: true,
                      options: subjects,
                      optionLabel: (s) => s.name,
                      optionId: (s) => s.id,
                      selectedIds: selectedSubjectIds,
                      onChanged: onSubjectsChanged,
                      emptyMessage: selectedClassIds.isEmpty
                          ? context.l10n.teacherSignupSelectClassFirst
                          : context.l10n.teacherSignupNoSubjectsFound,
                    ),
                    if (subjectsError != null) ...[
                      SizedBox(height: context.dimens.xs),
                      Text(
                        subjectsError!,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.dimens.xl),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: AppOutlinedButton(
                label: '← ${context.l10n.commonBack}',
                onPressed: onBack,
              ),
            ),
            SizedBox(width: context.dimens.md),
            Expanded(
              flex: 2,
              child: AppPrimaryButton(
                label: context.l10n.teacherSignupSubmitButton,
                loading: isSubmitting,
                onPressed: isSubmitting ? null : onSubmit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
