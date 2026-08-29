import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';

class StudentBasicInfoView extends ConsumerStatefulWidget {
  const StudentBasicInfoView({super.key});

  @override
  ConsumerState<StudentBasicInfoView> createState() =>
      _StudentBasicInfoViewState();
}

class _StudentBasicInfoViewState extends ConsumerState<StudentBasicInfoView> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue(Campus? selectedCampus) {
    final name = _nameController.text.trim();
    final errorNotifier = ref.read(studentNameErrorViewModelProvider.notifier);
    if (name.isEmpty) {
      errorNotifier.setError(context.l10n.commonRequiredField);
      return;
    }
    if (selectedCampus == null) return;
    errorNotifier.setError(null);

    final notifier = ref.read(studentOnboardingViewModelProvider.notifier);
    notifier.recordName(name);
    notifier.selectCampus(selectedCampus.id);
    context.push(AppRoutes.studentOnboardingAcademicInfo);
  }

  @override
  Widget build(BuildContext context) {
    final nameError = ref.watch(studentNameErrorViewModelProvider);
    final campusesAsync = ref.watch(campusesProvider);
    final selectedCampus = ref.watch(selectedCampusViewModelProvider);

    return OnboardingScaffold(
      currentStep: 1,
      totalSteps: 2,
      role: OnboardingRole.student,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.studentBasicInfoHeadline,
            subtitle: context.l10n.studentBasicInfoSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          AppTextField(
            label: context.l10n.nameLabel,
            hint: context.l10n.nameHint,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            errorText: nameError,
            isRequired: true,
          ),
          SizedBox(height: context.dimens.lg),
          AsyncValueWidget<List<Campus>>(
            value: campusesAsync,
            onRetry: () => ref.invalidate(campusesProvider),
            data: (campuses) => AppDropdownCard<Campus>(
              label: context.l10n.campusLabel,
              items: campuses,
              selectedItem: selectedCampus,
              isRequired: true,
              icon: Icons.location_city_rounded,
              itemAsString: (c) => '${c.name} (${c.city})',
              valueBuilder: (context, campus) {
                if (campus == null) {
                  return Text(
                    context.l10n.campusLabel,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.textSecondary.withValues(alpha: 0.7),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      campus.name,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          campus.city,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              itemBuilder: (context, campus, isDisabled, isSelected) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.md,
                    vertical: context.dimens.sm + 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: context.colors.divider.withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.colors.primary.withValues(alpha: 0.15)
                              : context.colors.divider.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.school_outlined,
                          size: 18,
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(width: context.dimens.sm + 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              campus.name,
                              style: context.textStyles.bodyMedium?.copyWith(
                                color: isSelected
                                    ? context.colors.primary
                                    : (isDisabled
                                        ? context.colors.textSecondary
                                            .withValues(alpha: 0.5)
                                        : context.colors.textPrimary),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 12,
                                  color: context.colors.textSecondary,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  campus.city,
                                  style: context.textStyles.bodySmall?.copyWith(
                                    color: context.colors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(width: context.dimens.sm),
                        Icon(
                          Icons.check_circle_rounded,
                          size: context.dimens.iconSm + 4,
                          color: context.colors.primary,
                        ),
                      ],
                    ],
                  ),
                );
              },
              onChanged: (campus) => ref
                  .read(selectedCampusViewModelProvider.notifier)
                  .select(campus),
            ),
          ),
          SizedBox(height: context.dimens.lg),
          AppPrimaryButton(
            label: context.l10n.commonContinue,
            onPressed: selectedCampus == null
                ? null
                : () => _continue(selectedCampus),
          ),
        ],
      ),
    );
  }
}
