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
/// - Step 1: Personal & Campus Information (Name + Campus)
/// - Step 2: Teaching Scope (Class >= 1, Subject >= 1, deduplicated)
/// - Step 3: Student Reach (Optional student counter)
/// - Step 4: Review Registration & Final Submit
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
  Campus? _campus;
  final Set<String> _selectedClassIds = {};
  final Set<String> _selectedSubjectNames = {};
  int? _declaredStudentCount;

  String? _nameError;
  String? _campusError;
  String? _classesError;
  String? _subjectsError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _classIdsKey {
    final sorted = _selectedClassIds.toList()..sort();
    return sorted.join(',');
  }

  void _onClassesChanged(Set<String> next) {
    setState(() {
      _selectedClassIds
        ..clear()
        ..addAll(next);
      _classesError = _selectedClassIds.isEmpty
          ? context.l10n.teacherSignupClassesRequiredError
          : null;
      // Clear out selected subjects that no longer exist for the selected classes
      _selectedSubjectNames.clear();
      _subjectsError = null;
    });
  }

  void _onSubjectsChanged(Set<String> next) {
    setState(() {
      _selectedSubjectNames
        ..clear()
        ..addAll(next);
      _subjectsError = _selectedSubjectNames.isEmpty
          ? context.l10n.teacherSignupSubjectsRequiredError
          : null;
    });
  }

  bool _validateStep1() {
    final name = _nameController.text.trim();
    setState(() {
      _nameError = Validators.isRequired(name)
          ? null
          : context.l10n.teacherSignupNameError;
      _campusError =
          _campus == null ? context.l10n.teacherSignupCampusError : null;
    });
    return _nameError == null && _campusError == null;
  }

  bool _validateStep2() {
    setState(() {
      _classesError = _selectedClassIds.isEmpty
          ? context.l10n.teacherSignupClassesRequiredError
          : null;
      _subjectsError = _selectedSubjectNames.isEmpty
          ? context.l10n.teacherSignupSubjectsRequiredError
          : null;
    });
    return _classesError == null && _subjectsError == null;
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
      AppSnackbar.show(context, 'Please complete all required fields.');
      return;
    }

    // Collect all actual subject IDs for the selected unique subjects
    final subjectsAsync =
        ref.read(teacherSignupSubjectsForClassesProvider(_classIdsKey));
    final availableSubjects = subjectsAsync.value ?? [];
    final allSelectedSubjectIds = <String>{};

    for (final opt in availableSubjects) {
      if (_selectedSubjectNames.contains(opt.name)) {
        allSelectedSubjectIds.addAll(opt.subjectIds);
      }
    }

    ref
        .read(teacherOnboardingViewModelProvider.notifier)
        .submitSignUp(
          name: _nameController.text.trim(),
          campusId: _campus!.id,
          subjectIds: allSelectedSubjectIds.toList(),
          classIds: _selectedClassIds.isEmpty ? null : _selectedClassIds.toList(),
          declaredStudentCount: _declaredStudentCount,
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
  // STEP 1: Personal & Campus Information
  // ---------------------------------------------------------------------------
  Widget _buildStep1() {
    final campusesAsync = ref.watch(teacherSignupCampusesProvider);

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

        /*
        // [ORIGINAL CODE WITH APPCARD - PRESERVED FOR EASY REVERT]:
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: '${context.l10n.nameLabel} *',
                hint: context.l10n.nameHint,
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                errorText: _nameError,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              SizedBox(height: context.dimens.lg),
              AsyncValueWidget<List<Campus>>(
                value: campusesAsync,
                onRetry: () => ref.invalidate(teacherSignupCampusesProvider),
                data: (campuses) => AppDropdown<Campus>(
                  label: '${context.l10n.campusLabel} *',
                  items: campuses,
                  selectedItem: _campus,
                  itemAsString: (c) => '${c.name} — ${c.city}',
                  onChanged: (campus) => setState(() {
                    _campus = campus;
                    _campusError = null;
                  }),
                ),
              ),
            ],
          ),
        ),
        */

        // [NEW OPEN CANVAS LAYOUT - WITHOUT APPCARD]:
        AppTextField(
          label: '${context.l10n.nameLabel} *',
          hint: context.l10n.nameHint,
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          errorText: _nameError,
          onChanged: (_) {
            if (_nameError != null) {
              setState(() => _nameError = null);
            }
          },
        ),
        SizedBox(height: context.dimens.lg),
        AsyncValueWidget<List<Campus>>(
          value: campusesAsync,
          onRetry: () => ref.invalidate(teacherSignupCampusesProvider),
          data: (campuses) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDropdown<Campus>(
                label: '${context.l10n.campusLabel} *',
                items: campuses,
                selectedItem: _campus,
                itemAsString: (c) => '${c.name} — ${c.city}',
                onChanged: (campus) => setState(() {
                  _campus = campus;
                  _campusError = null;
                }),
              ),
              if (_campusError != null) ...[
                SizedBox(height: context.dimens.xs),
                Text(
                  _campusError!,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ],
            ],
          ),
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
    final boardClassesAsync = ref.watch(teacherSignupClassOptionsProvider);
    final subjectsAsync = ref.watch(
      teacherSignupSubjectsForClassesProvider(_classIdsKey),
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

        // Classes Section
        _RequiredFieldLabel(
          label: context.l10n.teacherSignupClassesRequiredLabel,
        ),
        SizedBox(height: context.dimens.sm),

        /*
        // [ORIGINAL CODE WITH APPCARD - PRESERVED FOR EASY REVERT]:
        AppCard(
          child: AsyncValueWidget<List<TeacherClassOption>>(
            value: boardClassesAsync,
            onRetry: () => ref.invalidate(teacherSignupClassOptionsProvider),
            data: (boardClasses) => InteractiveSelectionGrid<TeacherClassOption>(
              options: boardClasses,
              optionLabel: (b) => b.displayName,
              optionId: (b) => b.id,
              optionIcon: (b) => _iconForClass(b.rawName),
              selectedIds: _selectedClassIds,
              onChanged: _onClassesChanged,
              emptyMessage: context.l10n.teacherSignupClassesEmpty,
            ),
          ),
        ),
        */

        // [NEW OPEN CANVAS LAYOUT - WITHOUT APPCARD]:
        AsyncValueWidget<List<TeacherClassOption>>(
          value: boardClassesAsync,
          onRetry: () => ref.invalidate(teacherSignupClassOptionsProvider),
          data: (boardClasses) => InteractiveSelectionGrid<TeacherClassOption>(
            options: boardClasses,
            optionLabel: (b) => b.displayName,
            optionId: (b) => b.id,
            optionIcon: (b) => _iconForClass(b.rawName),
            selectedIds: _selectedClassIds,
            onChanged: _onClassesChanged,
            emptyMessage: context.l10n.teacherSignupClassesEmpty,
          ),
        ),
        if (_classesError != null) ...[
          SizedBox(height: context.dimens.xs),
          Text(
            _classesError!,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
        ],

        SizedBox(height: context.dimens.lg),

        // Subjects Section (Deduplicated across selected classes)
        _RequiredFieldLabel(
          label: context.l10n.teacherSignupSubjectsRequiredLabel,
        ),
        SizedBox(height: context.dimens.sm),

        /*
        // [ORIGINAL CODE WITH APPCARD - PRESERVED FOR EASY REVERT]:
        AppCard(
          child: _selectedClassIds.isEmpty
              ? Text(context.l10n.teacherSignupSelectClassFirst)
              : AsyncValueWidget<List<UniqueTeacherSubject>>(...),
        ),
        */

        // [NEW OPEN CANVAS LAYOUT - WITHOUT APPCARD]:
        if (_selectedClassIds.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: context.dimens.md,
              horizontal: context.dimens.md,
            ),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
              border: Border.all(
                color: context.colors.divider,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  color: context.colors.primary,
                  size: context.dimens.iconMd,
                ),
                SizedBox(width: context.dimens.sm),
                Expanded(
                  child: Text(
                    context.l10n.teacherSignupSelectClassFirst,
                    style: context.textStyles.bodyMedium?.copyWith(
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
              teacherSignupSubjectsForClassesProvider(_classIdsKey),
            ),
            data: (subjects) =>
                InteractiveSelectionGrid<UniqueTeacherSubject>(
              options: subjects,
              optionLabel: (s) => s.name,
              optionId: (s) => s.name,
              optionIcon: (s) => _iconForSubject(s.name),
              selectedIds: _selectedSubjectNames,
              onChanged: _onSubjectsChanged,
              emptyMessage: context.l10n.teacherSignupNoSubjectsFound,
            ),
          ),
        if (_subjectsError != null) ...[
          SizedBox(height: context.dimens.xs),
          Text(
            _subjectsError!,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
        ],

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
          count: _declaredStudentCount,
          onChanged: (count) => setState(() => _declaredStudentCount = count),
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
    final boardClasses =
        ref.watch(teacherSignupClassOptionsProvider).value ?? [];

    final classNames = boardClasses
        .where((b) => _selectedClassIds.contains(b.id))
        .map((b) => b.displayName)
        .toList();

    final subjectNames = _selectedSubjectNames.toList()..sort();

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
          campusName:
              _campus != null ? '${_campus!.name} (${_campus!.city})' : '—',
          classNames: classNames,
          subjectNames: subjectNames,
          studentCount: _declaredStudentCount,
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

class _RequiredFieldLabel extends StatelessWidget {
  const _RequiredFieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyles.labelMedium?.copyWith(
        color: context.colors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
