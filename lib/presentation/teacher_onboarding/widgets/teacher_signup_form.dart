import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../viewmodel/teacher_signup_form_providers.dart';
import 'multi_select_chip_field.dart';

class TeacherSignupForm extends ConsumerStatefulWidget {
  const TeacherSignupForm({super.key});

  @override
  ConsumerState<TeacherSignupForm> createState() => _TeacherSignupFormState();
}

class _TeacherSignupFormState extends ConsumerState<TeacherSignupForm> {
  final _nameController = TextEditingController();
  final _studentCountController = TextEditingController();

  Campus? _campus;
  final Set<String> _selectedClassIds = {};
  final Set<String> _selectedSubjectIds = {};

  String? _nameError;
  String? _campusError;
  String? _subjectsError;

  @override
  void dispose() {
    _nameController.dispose();
    _studentCountController.dispose();
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
      _selectedSubjectIds.clear();
    });
  }

  bool _validate() {
    final name = _nameController.text.trim();
    setState(() {
      _nameError = Validators.isRequired(name) ? null : context.l10n.teacherSignupNameError;
      _campusError = _campus == null ? context.l10n.teacherSignupCampusError : null;
      _subjectsError = _selectedSubjectIds.isEmpty
          ? context.l10n.teacherSignupSubjectsError
          : null;
    });
    return _nameError == null && _campusError == null && _subjectsError == null;
  }

  void _handleSubmit() {
    if (!_validate()) return;

    final declaredStudentCount = int.tryParse(
      _studentCountController.text.trim(),
    );

    ref
        .read(teacherOnboardingViewModelProvider.notifier)
        .submitSignUp(
          name: _nameController.text.trim(),
          campusId: _campus!.id,
          subjectIds: _selectedSubjectIds.toList(),
          classIds: _selectedClassIds.isEmpty
              ? null
              : _selectedClassIds.toList(),
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

  @override
  Widget build(BuildContext context) {
    final campusesAsync = ref.watch(teacherSignupCampusesProvider);
    final boardClassesAsync = ref.watch(teacherSignupBoardClassesProvider);
    final subjectsAsync = ref.watch(
      teacherSignupSubjectsForClassesProvider(_classIdsKey),
    );
    final isSubmitting = ref.watch(
      teacherOnboardingViewModelProvider.select((s) => s.isLoading),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.dimens.contentMaxWidth),
        child: ListView(
          padding: EdgeInsets.all(context.dimens.lg),
          children: [
            Text(
              context.l10n.teacherSignupSubtitle,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimens.lg),
            AppTextField(
              label: context.l10n.nameLabel,
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              errorText: _nameError,
            ),
            SizedBox(height: context.dimens.lg),
            AsyncValueWidget<List<Campus>>(
              value: campusesAsync,
              onRetry: () => ref.invalidate(teacherSignupCampusesProvider),
              data: (campuses) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDropdown<Campus>(
                    label: context.l10n.campusLabel,
                    items: campuses,
                    selectedItem: _campus,
                    itemAsString: (c) => '${c.name} — ${c.city}',
                    onChanged: (campus) =>
                        setState(() => _campus = campus),
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
            SizedBox(height: context.dimens.lg),
            AsyncValueWidget<List<BoardClass>>(
              value: boardClassesAsync,
              onRetry: () => ref.invalidate(teacherSignupBoardClassesProvider),
              data: (boardClasses) => MultiSelectChipField<BoardClass>(
                label: context.l10n.teacherSignupClassesLabel,
                options: boardClasses,
                optionLabel: (b) => b.name,
                optionId: (b) => b.id,
                selectedIds: _selectedClassIds,
                onChanged: _onClassesChanged,
                emptyMessage: context.l10n.teacherSignupClassesEmpty,
              ),
            ),
            SizedBox(height: context.dimens.lg),
            AsyncValueWidget<List<Subject>>(
              value: subjectsAsync,
              onRetry: () => ref.invalidate(
                teacherSignupSubjectsForClassesProvider(_classIdsKey),
              ),
              data: (subjects) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MultiSelectChipField<Subject>(
                    label: context.l10n.teacherSignupSubjectsLabel,
                    options: subjects,
                    optionLabel: (s) => s.name,
                    optionId: (s) => s.id,
                    selectedIds: _selectedSubjectIds,
                    onChanged: (next) =>
                        setState(() => _selectedSubjectIds
                          ..clear()
                          ..addAll(next)),
                    emptyMessage: _selectedClassIds.isEmpty
                        ? context.l10n.teacherSignupSelectClassFirst
                        : context.l10n.teacherSignupNoSubjectsFound,
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
                ],
              ),
            ),
            SizedBox(height: context.dimens.lg),
            AppCard(
              child: AppTextField(
                label: context.l10n.teacherSignupApproxStudentsLabel,
                controller: _studentCountController,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: context.dimens.xl),
            AppPrimaryButton(
              label: context.l10n.teacherSignupSubmitButton,
              loading: isSubmitting,
              onPressed: isSubmitting ? null : _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
