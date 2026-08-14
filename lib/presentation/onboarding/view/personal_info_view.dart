import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/onboarding/entities/class_level.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../widgets/class_level_segmented_control.dart';
import '../widgets/onboarding_card_scaffold.dart';

class PersonalInfoView extends ConsumerStatefulWidget {
  const PersonalInfoView({super.key});

  @override
  ConsumerState<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends ConsumerState<PersonalInfoView> {
  late final TextEditingController _nameController;
  late final TextEditingController _classCodeController;
  String? _city;
  String? _college;
  ClassLevel? _classLevel;

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingViewModelProvider);
    _nameController = TextEditingController(text: s.name);
    _classCodeController = TextEditingController(text: s.classCode);
    _city = s.city.isEmpty ? null : s.city;
    _college = s.college.isEmpty ? null : s.college;
    _classLevel = s.classLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _classCodeController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      Validators.isRequired(_nameController.text) &&
      _city != null &&
      _college != null &&
      _classLevel != null &&
      Validators.isValidClassCode(_classCodeController.text.trim());

  void _onNext() {
    ref.read(onboardingViewModelProvider.notifier).setPersonalInfo(
          name: _nameController.text.trim(),
          city: _city!,
          college: _college!,
          classLevel: _classLevel!,
          classCode: _classCodeController.text.trim(),
        );
    context.push(AppRoutes.onboardingSubjectCount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final citiesAsync = ref.watch(cityOptionsProvider);
    final collegesAsync = ref.watch(collegeOptionsProvider);
    final classCodeValid = Validators.isValidClassCode(_classCodeController.text.trim());

    return OnboardingCardScaffold(
      icon: Icons.person_outline_rounded,
      title: context.l10n.personalInfoTitle,
      subtitle: context.l10n.personalInfoSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: context.l10n.nameLabel,
            hint: context.l10n.nameHint,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: dimens.md),
          citiesAsync.when(
            data: (cities) => AppDropdown<String>(
              label: context.l10n.cityLabel,
              items: cities,
              selectedItem: _city,
              onChanged: (value) => setState(() => _city = value),
            ),
            loading: () => const LoadingIndicator(),
            error: (_, _) => Text(context.l10n.commonErrorGeneric),
          ),

          SizedBox(height: dimens.xl),
          Text(
            context.l10n.personalInfoAcademicSection.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colors.primary,
            ),
          ),
          SizedBox(height: dimens.sm),
          collegesAsync.when(
            data: (colleges) => AppDropdown<String>(
              label: context.l10n.collegeLabel,
              items: colleges,
              selectedItem: _college,
              onChanged: (value) => setState(() => _college = value),
            ),
            loading: () => const LoadingIndicator(),
            error: (_, _) => Text(context.l10n.commonErrorGeneric),
          ),
          SizedBox(height: dimens.md),
          Text(
            context.l10n.classLevelLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: dimens.sm),
          ClassLevelSegmentedControl(
            selected: _classLevel,
            onChanged: (level) => setState(() => _classLevel = level),
          ),

          SizedBox(height: dimens.xl),
          Text(
            context.l10n.personalInfoOptionalSection.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: dimens.sm),
          AppTextField(
            label: context.l10n.classCodeLabel,
            hint: context.l10n.classCodeHint,
            controller: _classCodeController,
            maxLength: 6,
            textCapitalization: TextCapitalization.characters,
            onChanged: (_) => setState(() {}),
            errorText: classCodeValid ? null : context.l10n.commonRequiredField,
          ),
          SizedBox(height: dimens.xs),
          Text(
            context.l10n.classCodeNote,
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),

          SizedBox(height: dimens.xl),
          SizedBox(
            width: double.infinity,
            height: dimens.buttonHeight,
            child: ElevatedButton(
              onPressed: _isValid ? _onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.surfaceVariant,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dimens.pillRadius),
                ),
              ),
              child: Text(
                context.l10n.commonNext,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
