import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/campus_dropdown_card.dart';
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
      totalSteps: 3,
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
            prefixIcon: Icons.person_outline,
          ),
          SizedBox(height: context.dimens.lg),
          AsyncValueWidget<List<Campus>>(
            value: campusesAsync,
            onRetry: () => ref.invalidate(campusesProvider),
            data: (campuses) => CampusDropdownCard(
              items: campuses,
              selectedItem: selectedCampus,
              onChanged: (campus) => ref
                  .read(selectedCampusViewModelProvider.notifier)
                  .select(campus),
            ),
          ),
          SizedBox(height: context.dimens.lg),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (context, nameValue, _) => AppPrimaryButton(
              label: context.l10n.commonContinue,
              onPressed: (nameValue.text.trim().isEmpty || selectedCampus == null)
                  ? null
                  : () => _continue(selectedCampus),
            ),
          ),
        ],
      ),
    );
  }
}
