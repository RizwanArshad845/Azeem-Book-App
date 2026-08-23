import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/onboarding_icon_pattern_background.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
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
          Text(
            context.l10n.studentBasicInfoHeadline,
            style: context.textStyles.headlineSmall,
          ),
          SizedBox(height: context.dimens.sm),
          Text(
            context.l10n.studentBasicInfoSubtitle,
            style: context.textStyles.titleMedium,
          ),
          SizedBox(height: context.dimens.lg),
          AppTextField(
            label: context.l10n.nameLabel,
            hint: context.l10n.nameHint,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            errorText: nameError,
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
              icon: Icons.location_city_outlined,
              itemAsString: (c) => '${c.name} (${c.city})',
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
