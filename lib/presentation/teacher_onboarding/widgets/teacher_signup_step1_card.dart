import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/counter_input_field.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import 'teacher_section_header.dart';

/// Step 1 Card stateless component for Teacher Onboarding (Personal & Campus Info).
class TeacherSignupStep1Card extends StatelessWidget {
  const TeacherSignupStep1Card({
    super.key,
    required this.name,
    required this.campus,
    required this.studentCount,
    required this.campusesAsync,
    required this.nameError,
    required this.campusError,
    required this.onNameChanged,
    required this.onCampusChanged,
    required this.onStudentCountChanged,
    required this.onNext,
    required this.onRetryCampuses,
  });

  final String name;
  final Campus? campus;
  final int studentCount;
  final AsyncValue<List<Campus>> campusesAsync;
  final String? nameError;
  final String? campusError;
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
        TeacherSectionHeader(
          icon: Icons.person_outline,
          title: context.l10n.teacherSignupAboutYouSection,
          subtitle: context.l10n.personalInfoSubtitle,
        ),
        SizedBox(height: context.dimens.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: context.l10n.nameLabel,
                hint: context.l10n.nameHint,
                isRequired: true,
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
                    AppDropdown<Campus>(
                      label: context.l10n.campusLabel,
                      items: campuses,
                      selectedItem: campus,
                      itemAsString: (c) => '${c.name} — ${c.city}',
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
                onChanged: onStudentCountChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: '${context.l10n.commonNext} →',
          onPressed: onNext,
        ),
      ],
    );
  }
}
