import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../../domain/student_onboarding/usecases/update_student_subject_enrollments_usecase.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../viewmodel/student_home_viewmodel.dart';

/// Bottom sheet allowing a student to assign or change their teacher for an
/// enrolled subject after onboarding.
class AssignTeacherSheet extends ConsumerStatefulWidget {
  const AssignTeacherSheet({
    super.key,
    required this.subjectId,
    required this.subjectName,
    this.initialTeacherId,
  });

  final String subjectId;
  final String subjectName;
  final String? initialTeacherId;

  /// Utility method to present [AssignTeacherSheet] in an [AppBottomSheet].
  static Future<void> show({
    required BuildContext context,
    required String subjectId,
    required String subjectName,
    String? currentTeacherId,
  }) {
    return AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.subjectTeacherSelectTeacherLabel,
      subtitle: subjectName,
      child: AssignTeacherSheet(
        subjectId: subjectId,
        subjectName: subjectName,
        initialTeacherId: currentTeacherId,
      ),
    );
  }

  @override
  ConsumerState<AssignTeacherSheet> createState() => _AssignTeacherSheetState();
}

class _AssignTeacherSheetState extends ConsumerState<AssignTeacherSheet> {
  late String? _selectedTeacherId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedTeacherId = widget.initialTeacherId;
  }

  Future<void> _handleSave() async {
    final student = ref.read(currentStudentProvider);
    if (student == null) return;

    setState(() => _isSaving = true);

    final currentEnrollments = student.subjectEnrollments ?? <SubjectEnrollment>[];
    final updatedEnrollments = <SubjectEnrollment>[];
    var found = false;

    for (final enrollment in currentEnrollments) {
      if (enrollment.subjectId == widget.subjectId) {
        found = true;
        updatedEnrollments.add(
          enrollment.copyWith(
            teacherId: _selectedTeacherId,
            discountApplied: _selectedTeacherId != null,
          ),
        );
      } else {
        updatedEnrollments.add(enrollment);
      }
    }

    if (!found) {
      updatedEnrollments.add(
        SubjectEnrollment.create(
          studentId: student.id,
          subjectId: widget.subjectId,
          teacherId: _selectedTeacherId,
          discountApplied: _selectedTeacherId != null,
        ),
      );
    }

    final result = await sl<UpdateStudentSubjectEnrollmentsUseCase>()(
      student.id,
      updatedEnrollments,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.when(
      success: (savedEnrollments) {
        ref.read(studentOnboardingViewModelProvider.notifier).setStudent(
              student.copyWith(subjectEnrollments: savedEnrollments),
            );
        Navigator.of(context).pop();
        AppSnackbar.show(
          context,
          _selectedTeacherId != null
              ? 'Teacher assigned successfully'
              : 'Set to self-study',
        );
      },
      failure: (failure) {
        AppSnackbar.show(
          context,
          failure.message.isNotEmpty
              ? failure.message
              : context.l10n.commonErrorGeneric,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(currentStudentProvider);
    final campusId = student?.campusId ?? '';
    final teachersAsync = campusId.isNotEmpty
        ? ref.watch(teachersForCampusProvider(campusId))
        : null;

    final hasChanged = _selectedTeacherId != widget.initialTeacherId;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.md,
        vertical: context.dimens.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Option: Self-study (No teacher)
          AppCard(
            onTap: () => setState(() => _selectedTeacherId = null),
            child: Row(
              children: [
                Radio<String?>(
                  value: null,
                  groupValue: _selectedTeacherId,
                  onChanged: (val) => setState(() => _selectedTeacherId = val),
                  activeColor: context.colors.primary,
                ),
                SizedBox(width: context.dimens.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Self-study (No Teacher)',
                        style: context.textStyles.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.dimens.xs / 2),
                      Text(
                        'Study independently without campus teacher discount',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.dimens.sm),

          // Teachers list
          if (teachersAsync != null)
            AsyncValueWidget<List<TeacherOption>>(
              value: teachersAsync,
              skeleton: const SkeletonList(itemCount: 3),
              onRetry: () => ref.invalidate(teachersForCampusProvider(campusId)),
              data: (teachers) {
                final subjectTeachers = teachers
                    .where((t) => t.subjectIds.contains(widget.subjectId))
                    .toList();

                if (subjectTeachers.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: context.dimens.md),
                    child: Center(
                      child: Text(
                        context.l10n.subjectTeacherSelectNoTeachers,
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final teacher in subjectTeachers) ...[
                      AppCard(
                        onTap: () => setState(() => _selectedTeacherId = teacher.id),
                        child: Row(
                          children: [
                            Radio<String?>(
                              value: teacher.id,
                              groupValue: _selectedTeacherId,
                              onChanged: (val) =>
                                  setState(() => _selectedTeacherId = val),
                              activeColor: context.colors.primary,
                            ),
                            SizedBox(width: context.dimens.xs),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacher.name,
                                    style: context.textStyles.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: context.dimens.xs / 2),
                                  Text(
                                    'Campus Teacher',
                                    style: context.textStyles.bodySmall?.copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(
                              label: context.l10n.subjectTeacherSelectDiscountApplied,
                              color: context.colors.success,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.dimens.sm),
                    ],
                  ],
                );
              },
            ),

          SizedBox(height: context.dimens.md),
          AppPrimaryButton(
            label: context.l10n.commonSave,
            loading: _isSaving,
            onPressed: hasChanged && !_isSaving ? _handleSave : null,
          ),
          SizedBox(height: context.dimens.sm),
        ],
      ),
    );
  }
}
