import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../viewmodel/assign_teacher_viewmodel.dart';
import '../viewmodel/student_home_viewmodel.dart';

/// Bottom sheet allowing a student to assign or change their teacher for an
/// enrolled subject after onboarding.
class AssignTeacherSheet extends ConsumerWidget {
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
  static void show({
    required BuildContext context,
    required String subjectId,
    required String subjectName,
    String? currentTeacherId,
  }) {
    AppBottomSheet.show<void>(
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
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(assignTeacherViewModelProvider(initialTeacherId).notifier);
    final vmState = ref.watch(assignTeacherViewModelProvider(initialTeacherId));

    final student = ref.watch(currentStudentProvider);
    final campusId = student?.campusId ?? '';
    final teachersAsync = campusId.isNotEmpty
        ? ref.watch(teachersForCampusProvider(campusId))
        : null;

    final hasChanged = vmState.selectedTeacherId != initialTeacherId;

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
            onTap: () => vm.select(null),
            child: Row(
              children: [
                Radio<String?>(
                  value: null,
                  groupValue: vmState.selectedTeacherId,
                  onChanged: vm.select,
                  activeColor: context.colors.primary,
                ),
                SizedBox(width: context.dimens.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.assignTeacherSelfStudyTitle,
                        style: context.textStyles.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.dimens.xs / 2),
                      Text(
                        context.l10n.assignTeacherSelfStudySubtitle,
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
                    .where((t) => t.subjectIds.contains(subjectId))
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
                        onTap: () => vm.select(teacher.id),
                        child: Row(
                          children: [
                            Radio<String?>(
                              value: teacher.id,
                              groupValue: vmState.selectedTeacherId,
                              onChanged: vm.select,
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
                                    context.l10n.assignTeacherCampusTeacherLabel,
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
            loading: vmState.isSaving,
            onPressed: hasChanged && !vmState.isSaving
                ? () => vm.save(
                      ref: ref,
                      context: context,
                      subjectId: subjectId,
                    )
                : null,
          ),
          SizedBox(height: context.dimens.sm),
        ],
      ),
    );
  }
}
