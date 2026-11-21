import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../core/utils/validators.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../auth/widgets/onboarding_logout_action.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';

class StudentBasicInfoView extends ConsumerStatefulWidget {
  const StudentBasicInfoView({super.key});

  @override
  ConsumerState<StudentBasicInfoView> createState() =>
      _StudentBasicInfoViewState();
}

class _StudentBasicInfoViewState extends ConsumerState<StudentBasicInfoView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneError = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    // Keep what was typed when coming Back from a later step; otherwise
    // prefill the name from the Google account.
    final notifier = ref.read(studentOnboardingViewModelProvider.notifier);
    _nameController.text =
        notifier.name ?? ref.read(currentUserProvider)?.name?.trim() ?? '';
    _phoneController.text = notifier.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _phoneError.dispose();
    super.dispose();
  }

  void _continue(Campus? selectedCampus) {
    final name = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final errorNotifier = ref.read(studentNameErrorViewModelProvider.notifier);
    if (name.isEmpty) {
      errorNotifier.setError(context.l10n.commonRequiredField);
      return;
    }
    errorNotifier.setError(null);
    if (!Validators.isValidPhoneLocal(phoneNumber)) {
      _phoneError.value = context.l10n.phoneInvalid;
      return;
    }
    _phoneError.value = null;
    if (selectedCampus == null) return;

    final notifier = ref.read(studentOnboardingViewModelProvider.notifier);
    notifier.recordName(name);
    notifier.recordPhoneNumber(phoneNumber);
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
      onLogout: () => confirmOnboardingLogout(context, ref),
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
          ValueListenableBuilder<String?>(
            valueListenable: _phoneError,
            builder: (context, phoneError, _) => AppTextField(
              label: context.l10n.phoneLabel,
              hint: context.l10n.phoneHint,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 11,
              errorText: phoneError,
              isRequired: true,
              prefixIcon: Icons.phone_outlined,
              onChanged: (_) => _phoneError.value = null,
            ),
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
          ListenableBuilder(
            listenable: Listenable.merge([_nameController, _phoneController]),
            builder: (context, _) => AppPrimaryButton(
              label: context.l10n.commonContinue,
              onPressed:
                  (_nameController.text.trim().isEmpty ||
                      _phoneController.text.trim().isEmpty ||
                      selectedCampus == null)
                  ? null
                  : () => _continue(selectedCampus),
            ),
          ),
        ],
      ),
    );
  }
}
