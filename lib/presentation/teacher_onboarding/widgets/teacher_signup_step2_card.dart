import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/multi_select_option_row.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/subject.dart';

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
        OnboardingStepHeader(
          title: context.l10n.teacherSignupWhatYouTeachSection,
          subtitle: context.l10n.boardClassSelectSubtitle,
        ),
        SizedBox(height: context.dimens.lg),
        AsyncValueWidget<List<BoardClass>>(
          value: boardClassesAsync,
          onRetry: onRetryBoardClasses,
          data: (boardClasses) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RequiredFieldLabel(context.l10n.teacherSignupClassesLabel),
              SizedBox(height: context.dimens.xs),
              if (boardClasses.isEmpty)
                EmptyStateView(
                  message: context.l10n.teacherSignupClassesEmpty,
                )
              else
                for (final boardClass in boardClasses) ...[
                  MultiSelectOptionRow(
                    label: boardClass.name,
                    isSelected: selectedClassIds.contains(boardClass.id),
                    onSelectedChanged: (isSelected) {
                      final next = Set<String>.of(selectedClassIds);
                      if (isSelected) {
                        next.add(boardClass.id);
                      } else {
                        next.remove(boardClass.id);
                      }
                      onClassesChanged(next);
                    },
                  ),
                  SizedBox(height: context.dimens.sm),
                ],
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
              _RequiredFieldLabel(context.l10n.teacherSignupSubjectsLabel),
              SizedBox(height: context.dimens.xs),
              if (subjects.isEmpty)
                EmptyStateView(
                  message: selectedClassIds.isEmpty
                      ? context.l10n.teacherSignupSelectClassFirst
                      : context.l10n.teacherSignupNoSubjectsFound,
                )
              else
                for (final subject in subjects) ...[
                  MultiSelectOptionRow(
                    label: subject.name,
                    isSelected: selectedSubjectIds.contains(subject.id),
                    onSelectedChanged: (isSelected) {
                      final next = Set<String>.of(selectedSubjectIds);
                      if (isSelected) {
                        next.add(subject.id);
                      } else {
                        next.remove(subject.id);
                      }
                      onSubjectsChanged(next);
                    },
                  ),
                  SizedBox(height: context.dimens.sm),
                ],
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
                label: context.l10n.commonContinue,
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

/// Field label with a red required asterisk, matching [AppDropdownCard]'s
/// required-label styling so classes/subjects read consistently with the
/// campus dropdown above them.
class _RequiredFieldLabel extends StatelessWidget {
  const _RequiredFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: context.textStyles.labelLarge?.copyWith(
          color: context.colors.textSecondary,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(color: context.colors.error),
          ),
        ],
      ),
    );
  }
}
