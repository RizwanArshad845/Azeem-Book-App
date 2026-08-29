import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../viewmodel/teacher_signup_form_providers.dart';
import 'interactive_selection_grid.dart';
import 'student_count_counter.dart';
import 'teacher_onboarding_summary_card.dart';

/// Multi-step Teacher Signup Form wizard broken down into:
/// - Step 1: Personal & Campus Information (Name + City filter + Multi-Campus)
/// - Step 2: Teaching Scope (Class >= 1, Subject >= 1, deduplicated)
/// - Step 3: Student Reach (Optional student counter)
/// - Step 4: Review Registration & Final Submit
///
/// Business state (city/campuses/classes/subjects/student count + field
/// errors) lives in `teacher_signup_form_providers.dart` as small dedicated
/// Riverpod Notifiers — this is the actual `submitSignUp(...)` payload, so it
/// must not live in raw `setState` fields (CLAUDE.md §2). Only `_nameController`
/// stays local: it's a `TextEditingController`, legitimately ephemeral UI state.
class TeacherSignupForm extends ConsumerStatefulWidget {
  const TeacherSignupForm({
    super.key,
    required this.currentStep,
    required this.onStepChanged,
  });

  final int currentStep;
  final ValueChanged<int> onStepChanged;

  @override
  ConsumerState<TeacherSignupForm> createState() => _TeacherSignupFormState();
}

class _TeacherSignupFormState extends ConsumerState<TeacherSignupForm> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fresh business state every time the wizard is (re)shown, so a previous
    // attempt never leaks into a new one.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) resetTeacherSignupFormState(ref);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _classIdsKey(Set<String> classIds) {
    final sorted = classIds.toList()..sort();
    return sorted.join(',');
  }

  void _onClassesChanged(Set<String> next) {
    ref.read(teacherSignupSelectedClassIdsProvider.notifier).setClassIds(next);
    ref
        .read(teacherSignupClassesErrorProvider.notifier)
        .set(next.isEmpty ? context.l10n.teacherSignupClassesRequiredError : null);
    // Clear out selected subjects that no longer exist for the selected classes
    ref.read(teacherSignupSelectedSubjectNamesProvider.notifier).clear();
    ref.read(teacherSignupSubjectsErrorProvider.notifier).set(null);
  }

  void _onSubjectsChanged(Set<String> next) {
    ref
        .read(teacherSignupSelectedSubjectNamesProvider.notifier)
        .setSubjectNames(next);
    ref
        .read(teacherSignupSubjectsErrorProvider.notifier)
        .set(next.isEmpty ? context.l10n.teacherSignupSubjectsRequiredError : null);
  }

  bool _validateStep1() {
    final name = _nameController.text.trim();
    final selectedCity = ref.read(teacherSignupSelectedCityProvider);
    final selectedCampusIds = ref.read(teacherSignupSelectedCampusIdsProvider);

    final nameError = Validators.isRequired(name)
        ? null
        : context.l10n.teacherSignupNameError;
    final cityError =
        selectedCity == null ? context.l10n.teacherSignupCityError : null;
    final campusesError = selectedCampusIds.isEmpty
        ? context.l10n.teacherSignupCampusesError
        : null;

    ref.read(teacherSignupNameErrorProvider.notifier).set(nameError);
    ref.read(teacherSignupCityErrorProvider.notifier).set(cityError);
    ref.read(teacherSignupCampusesErrorProvider.notifier).set(campusesError);

    return nameError == null && cityError == null && campusesError == null;
  }

  bool _validateStep2() {
    final selectedClassIds = ref.read(teacherSignupSelectedClassIdsProvider);
    final selectedSubjectNames =
        ref.read(teacherSignupSelectedSubjectNamesProvider);

    final classesError = selectedClassIds.isEmpty
        ? context.l10n.teacherSignupClassesRequiredError
        : null;
    final subjectsError = selectedSubjectNames.isEmpty
        ? context.l10n.teacherSignupSubjectsRequiredError
        : null;

    ref.read(teacherSignupClassesErrorProvider.notifier).set(classesError);
    ref.read(teacherSignupSubjectsErrorProvider.notifier).set(subjectsError);

    return classesError == null && subjectsError == null;
  }

  void _handleNextFromStep1() {
    if (_validateStep1()) {
      widget.onStepChanged(2);
    }
  }

  void _handleNextFromStep2() {
    if (_validateStep2()) {
      widget.onStepChanged(3);
    }
  }

  void _handleNextFromStep3() {
    widget.onStepChanged(4);
  }

  void _handleSubmit() {
    if (!_validateStep1() || !_validateStep2()) {
      AppSnackbar.show(context, context.l10n.teacherSignupCompleteFieldsError);
      return;
    }

    final selectedClassIds = ref.read(teacherSignupSelectedClassIdsProvider);
    final selectedSubjectNames =
        ref.read(teacherSignupSelectedSubjectNamesProvider);
    final selectedCampusIds = ref.read(teacherSignupSelectedCampusIdsProvider);
    final declaredStudentCount =
        ref.read(teacherSignupDeclaredStudentCountProvider);

    // Collect all actual subject IDs for the selected unique subjects
    final subjectsAsync = ref.read(
      teacherSignupSubjectsForClassesProvider(_classIdsKey(selectedClassIds)),
    );
    final availableSubjects = subjectsAsync.value ?? [];
    final allSelectedSubjectIds = <String>{};

    for (final opt in availableSubjects) {
      if (selectedSubjectNames.contains(opt.name)) {
        allSelectedSubjectIds.addAll(opt.subjectIds);
      }
    }

    final primaryCampusId =
        selectedCampusIds.isNotEmpty ? selectedCampusIds.first : '';

    ref
        .read(teacherOnboardingViewModelProvider.notifier)
        .submitSignUp(
          name: _nameController.text.trim(),
          campusId: primaryCampusId,
          subjectIds: allSelectedSubjectIds.toList(),
          classIds: selectedClassIds.isEmpty ? null : selectedClassIds.toList(),
          declaredStudentCount: declaredStudentCount,
        )
        .then((success) {
      if (!mounted || success) return;
      final failure = ref.read(teacherOnboardingViewModelProvider).error;
      AppSnackbar.show(
        context,
        failure is Failure ? failure.message : context.l10n.commonErrorGeneric,
      );
    });
  }

  IconData _iconForClass(String className) {
    final name = className.toLowerCase();
    if (name.contains('med')) return Icons.medical_services_outlined;
    if (name.contains('eng')) return Icons.architecture_outlined;
    if (name.contains('ics') || name.contains('comp')) {
      return Icons.devices_outlined;
    }
    if (name.contains('com')) return Icons.bar_chart_outlined;
    if (name.contains('art') || name.contains('fa')) return Icons.palette_outlined;
    return Icons.school_outlined;
  }

  IconData _iconForSubject(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('physic')) return Icons.bolt_outlined;
    if (name.contains('chem')) return Icons.science_outlined;
    if (name.contains('bio')) return Icons.eco_outlined;
    if (name.contains('math')) return Icons.calculate_outlined;
    if (name.contains('computer') || name.contains('cs')) {
      return Icons.computer_outlined;
    }
    if (name.contains('eng')) return Icons.menu_book_outlined;
    if (name.contains('urdu')) return Icons.auto_stories_outlined;
    if (name.contains('islam')) return Icons.mosque_outlined;
    if (name.contains('pak')) return Icons.flag_outlined;
    return Icons.menu_book_outlined;
  }

  IconData _forwardIcon(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl
        ? Icons.arrow_back_rounded
        : Icons.arrow_forward_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      teacherOnboardingViewModelProvider.select((s) => s.isLoading),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildCurrentStep(isSubmitting),
    );
  }

  Widget _buildCurrentStep(bool isSubmitting) {
    switch (widget.currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
      default:
        return _buildStep4(isSubmitting);
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 1: Personal & Campus Information (City Filter + Multi-Campus)
  // ---------------------------------------------------------------------------
  Widget _buildStep1() {
    final citiesAsync = ref.watch(teacherSignupCitiesProvider);
    final selectedCity = ref.watch(teacherSignupSelectedCityProvider);
    final selectedCampusIds = ref.watch(teacherSignupSelectedCampusIdsProvider);
    final nameError = ref.watch(teacherSignupNameErrorProvider);
    final cityError = ref.watch(teacherSignupCityErrorProvider);
    final campusesError = ref.watch(teacherSignupCampusesErrorProvider);

    return Column(
      key: const ValueKey(1),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          title: context.l10n.teacherSignupStep1Title,
          subtitle: context.l10n.teacherSignupStep1Subtitle,
        ),
        SizedBox(height: context.dimens.lg),

        // Full Name
        AppTextField(
          label: context.l10n.teacherSignupNameRequiredLabel,
          hint: context.l10n.nameHint,
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          errorText: nameError,
          onChanged: (_) {
            if (nameError != null) {
              ref.read(teacherSignupNameErrorProvider.notifier).set(null);
            }
          },
        ),
        SizedBox(height: context.dimens.lg),

        // City Dropdown
        AsyncValueWidget<List<String>>(
          value: citiesAsync,
          onRetry: () => ref.invalidate(teacherSignupCitiesProvider),
          data: (cities) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDropdown<String>(
                label: context.l10n.teacherSignupCityLabel,
                items: cities,
                selectedItem: selectedCity,
                itemAsString: (city) => city,
                onChanged: (city) {
                  ref
                      .read(teacherSignupSelectedCityProvider.notifier)
                      .setCity(city);
                  ref.read(teacherSignupSelectedCampusIdsProvider.notifier).clear();
                  ref.read(teacherSignupCityErrorProvider.notifier).set(null);
                  ref
                      .read(teacherSignupCampusesErrorProvider.notifier)
                      .set(null);
                },
              ),
              if (cityError != null) ...[
                SizedBox(height: context.dimens.xs),
                Text(
                  cityError,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: context.dimens.lg),

        // Filtered Campuses Selection
        if (selectedCity == null)
          Container(
            padding: EdgeInsets.all(context.dimens.md),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: context.colors.primary,
                  size: context.dimens.iconSm,
                ),
                SizedBox(width: context.dimens.sm),
                Expanded(
                  child: Text(
                    context.l10n.teacherSignupSelectCityFirst,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Consumer(
            builder: (context, ref, _) {
              final campusesAsync = ref.watch(
                teacherSignupCampusesByCityProvider(selectedCity),
              );

              return AsyncValueWidget<List<Campus>>(
                value: campusesAsync,
                onRetry: () => ref.invalidate(
                  teacherSignupCampusesByCityProvider(selectedCity),
                ),
                data: (campuses) {
                  return InteractiveSelectionGrid<Campus>(
                    label: context.l10n.teacherSignupCampusesLabel,
                    items: campuses,
                    selectedIds: selectedCampusIds,
                    idExtractor: (c) => c.id,
                    labelExtractor: (c) => c.name,
                    iconExtractor: (_) => Icons.account_balance_outlined,
                    onSelectionChanged: (next) {
                      ref
                          .read(teacherSignupSelectedCampusIdsProvider.notifier)
                          .setCampusIds(next);
                      if (next.isNotEmpty) {
                        ref
                            .read(teacherSignupCampusesErrorProvider.notifier)
                            .set(null);
                      }
                    },
                    errorText: campusesError,
                  );
                },
              );
            },
          ),

        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: context.l10n.commonContinue,
          icon: _forwardIcon(context),
          onPressed: _handleNextFromStep1,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2: Teaching Scope (Classes & Subjects)
  // ---------------------------------------------------------------------------
  Widget _buildStep2() {
    final selectedClassIds = ref.watch(teacherSignupSelectedClassIdsProvider);
    final selectedSubjectNames =
        ref.watch(teacherSignupSelectedSubjectNamesProvider);
    final classesError = ref.watch(teacherSignupClassesErrorProvider);
    final subjectsError = ref.watch(teacherSignupSubjectsErrorProvider);

    final classIdsKey = _classIdsKey(selectedClassIds);
    final boardClassesAsync = ref.watch(teacherSignupClassOptionsProvider);
    final subjectsAsync = ref.watch(
      teacherSignupSubjectsForClassesProvider(classIdsKey),
    );

    return Column(
      key: const ValueKey(2),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          title: context.l10n.teacherSignupStep2Title,
          subtitle: context.l10n.teacherSignupStep2Subtitle,
        ),
        SizedBox(height: context.dimens.lg),

        // Classes Multi-select
        AsyncValueWidget<List<TeacherClassOption>>(
          value: boardClassesAsync,
          onRetry: () => ref.invalidate(teacherSignupClassOptionsProvider),
          data: (options) {
            return InteractiveSelectionGrid<TeacherClassOption>(
              label: context.l10n.teacherSignupClassesRequiredLabel,
              items: options,
              selectedIds: selectedClassIds,
              idExtractor: (opt) => opt.id,
              labelExtractor: (opt) => opt.displayName,
              iconExtractor: (opt) => _iconForClass(opt.displayName),
              onSelectionChanged: _onClassesChanged,
              errorText: classesError,
            );
          },
        ),
        SizedBox(height: context.dimens.xl),

        // Subjects Multi-select
        if (selectedClassIds.isEmpty)
          Container(
            padding: EdgeInsets.all(context.dimens.md),
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
              border: Border.all(
                color: context.colors.divider.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: context.colors.textSecondary,
                  size: context.dimens.iconSm,
                ),
                SizedBox(width: context.dimens.sm),
                Expanded(
                  child: Text(
                    context.l10n.teacherSignupSelectClassForSubjects,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          AsyncValueWidget<List<UniqueTeacherSubject>>(
            value: subjectsAsync,
            onRetry: () => ref.invalidate(
              teacherSignupSubjectsForClassesProvider(classIdsKey),
            ),
            data: (uniqueSubjects) {
              return InteractiveSelectionGrid<UniqueTeacherSubject>(
                label: context.l10n.teacherSignupSubjectsRequiredLabel,
                items: uniqueSubjects,
                selectedIds: selectedSubjectNames,
                idExtractor: (s) => s.name,
                labelExtractor: (s) => s.name,
                iconExtractor: (s) => _iconForSubject(s.name),
                onSelectionChanged: _onSubjectsChanged,
                errorText: subjectsError,
              );
            },
          ),

        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: context.l10n.commonContinue,
          icon: _forwardIcon(context),
          onPressed: _handleNextFromStep2,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: Student Reach (Optional Counter)
  // ---------------------------------------------------------------------------
  Widget _buildStep3() {
    final declaredStudentCount =
        ref.watch(teacherSignupDeclaredStudentCountProvider);

    return Column(
      key: const ValueKey(3),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          title: context.l10n.teacherSignupStep3Title,
          subtitle: context.l10n.teacherSignupStep3Subtitle,
        ),
        SizedBox(height: context.dimens.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.teacherSignupApproxStudentsLabel,
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: context.dimens.xs),
        StudentCountCounter(
          count: declaredStudentCount,
          onChanged: (count) => ref
              .read(teacherSignupDeclaredStudentCountProvider.notifier)
              .setCount(count),
        ),
        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: context.l10n.commonContinue,
          icon: _forwardIcon(context),
          onPressed: _handleNextFromStep3,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 4: Review Registration & Submit
  // ---------------------------------------------------------------------------
  Widget _buildStep4(bool isSubmitting) {
    final selectedCity = ref.watch(teacherSignupSelectedCityProvider);
    final selectedCampusIds = ref.watch(teacherSignupSelectedCampusIdsProvider);
    final selectedClassIds = ref.watch(teacherSignupSelectedClassIdsProvider);
    final selectedSubjectNames =
        ref.watch(teacherSignupSelectedSubjectNamesProvider);
    final declaredStudentCount =
        ref.watch(teacherSignupDeclaredStudentCountProvider);

    final allCampuses =
        ref.watch(teacherSignupCampusesProvider).value ?? <Campus>[];
    final selectedCampuses =
        allCampuses.where((c) => selectedCampusIds.contains(c.id)).toList();
    final campusNames = selectedCampuses.map((c) => c.name).toList();

    final boardClasses =
        ref.watch(teacherSignupClassOptionsProvider).value ?? [];

    final classNames = boardClasses
        .where((b) => selectedClassIds.contains(b.id))
        .map((b) => b.displayName)
        .toList();

    final subjectNames = selectedSubjectNames.toList()..sort();

    return Column(
      key: const ValueKey(4),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          title: context.l10n.teacherSignupStep4Title,
          subtitle: context.l10n.teacherSignupStep4Subtitle,
        ),
        SizedBox(height: context.dimens.lg),

        // Review Summary Card
        TeacherOnboardingSummaryCard(
          name: _nameController.text.trim(),
          cityName: selectedCity ?? '—',
          campusNames: campusNames,
          classNames: classNames,
          subjectNames: subjectNames,
          studentCount: declaredStudentCount,
        ),

        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: context.l10n.teacherSignupSubmitButton,
          icon: Icons.check_circle_outline_rounded,
          loading: isSubmitting,
          onPressed: isSubmitting ? null : _handleSubmit,
        ),
      ],
    );
  }
}
