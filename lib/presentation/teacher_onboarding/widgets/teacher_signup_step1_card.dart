import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/campus_dropdown_card.dart';
import '../../../core/widgets/counter_input_field.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/campus_directory/entities/campus.dart';

/// Step 1 Card stateless component for Teacher Onboarding (Personal & Campus Info).
class TeacherSignupStep1Card extends StatelessWidget {
  const TeacherSignupStep1Card({
    super.key,
    required this.nameController,
    required this.campus,
    required this.studentCount,
    required this.campusesAsync,
    required this.nameError,
    required this.campusError,
    required this.isNextEnabled,
    required this.onNameChanged,
    required this.onCampusChanged,
    required this.onStudentCountChanged,
    required this.onNext,
    required this.onRetryCampuses,
  });

  final TextEditingController nameController;
  final Campus? campus;
  final int studentCount;
  final AsyncValue<List<Campus>> campusesAsync;
  final String? nameError;
  final String? campusError;
  final bool isNextEnabled;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<Campus?> onCampusChanged;
  final ValueChanged<int> onStudentCountChanged;
  final VoidCallback onNext;
  final VoidCallback onRetryCampuses;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          title: context.l10n.teacherSignupAboutYouSection,
          subtitle: context.l10n.personalInfoSubtitle,
        ),
        SizedBox(height: context.dimens.lg),
        AppTextField(
          label: context.l10n.nameLabel,
          hint: context.l10n.nameHint,
          controller: nameController,
          isRequired: true,
          prefixIcon: Icons.person_outline,
          textCapitalization: TextCapitalization.words,
          errorText: nameError,
          onChanged: onNameChanged,
        ),
        SizedBox(height: context.dimens.lg),
        AsyncValueWidget<List<Campus>>(
          value: campusesAsync,
          onRetry: onRetryCampuses,
          data: (campuses) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampusDropdownCard(
                items: campuses,
                selectedItem: campus,
                onChanged: onCampusChanged,
              ),
              if (campusError != null) ...[
                SizedBox(height: context.dimens.xs),
                Text(
                  campusError!,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: context.dimens.lg),
        CounterInputField(
          label: context.l10n.teacherSignupApproxStudentsLabel,
          value: studentCount,
          min: 0,
          max: 5000,
          icon: Icons.groups_outlined,
          onChanged: onStudentCountChanged,
        ),
        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: '${context.l10n.commonNext} →',
          onPressed: isNextEnabled ? onNext : null,
        ),
      ],
    );
  }
}
