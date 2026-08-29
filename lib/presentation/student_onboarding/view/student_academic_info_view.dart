import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/class_level.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';
import '../widgets/catalog_option_row.dart';
import '../widgets/subject_row.dart';

/// Step 2/2 of student onboarding — class -> (conditional) group ->
/// subjects+teacher, all on one screen (§3 of the onboarding-merge plan).
/// Board/class is asked as two dependent picks instead of one flat list:
/// most `ClassLevel`s (9th/10th) resolve to a single `BoardClass` leaf and
/// skip straight to subjects; 11th/12th have two leaves (Pre-Medical/
/// Pre-Engineering) and show a Group picker in between.
class StudentAcademicInfoView extends ConsumerWidget {
  const StudentAcademicInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classLevelsAsync = ref.watch(classLevelsProvider);
    final selectedClassLevelId = ref.watch(selectedClassLevelViewModelProvider);
    final selectedBoardClassId = ref.watch(selectedBoardClassViewModelProvider);
    final selections = ref.watch(subjectSelectionViewModelProvider);

    AsyncValue<List<BoardClass>>? boardClassesAsync;
    if (selectedClassLevelId != null) {
      final provider = boardClassesForClassLevelProvider(selectedClassLevelId);
      boardClassesAsync = ref.watch(provider);
      // Auto-select the only leaf for class levels that don't split into
      // groups (9th/10th) so the student never sees a pointless 1-option
      // picker — the Group section below only renders when there's an
      // actual choice to make.
      ref.listen(provider, (previous, next) {
        final leaves = next.value;
        if (leaves != null && leaves.length == 1) {
          ref
              .read(selectedBoardClassViewModelProvider.notifier)
              .select(leaves.first.id);
        }
      });
    }

    return OnboardingScaffold(
      currentStep: 2,
      totalSteps: 2,
      role: OnboardingRole.student,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.studentAcademicInfoHeadline,
            subtitle: context.l10n.studentAcademicInfoSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          _SectionLabel(context.l10n.studentAcademicInfoClassLabel),
          SizedBox(height: context.dimens.sm),
          AsyncValueWidget<List<ClassLevel>>(
            value: classLevelsAsync,
            onRetry: () => ref.invalidate(classLevelsProvider),
            data: (classLevels) => classLevels.isEmpty
                ? EmptyStateView(message: context.l10n.boardClassSelectEmpty)
                : Column(
                    children: [
                      for (final level in classLevels) ...[
                        CatalogOptionRow(
                          label: level.name,
                          icon: _classLevelIcon(level.name),
                          isEnabled: level.isEnabled,
                          isSelected: level.id == selectedClassLevelId,
                          onTap: level.isEnabled
                              ? () => ref
                                  .read(selectedClassLevelViewModelProvider.notifier)
                                  .select(level.id)
                              : null,
                        ),
                        SizedBox(height: context.dimens.sm),
                      ],
                    ],
                  ),
          ),
          if (boardClassesAsync != null)
            AsyncValueWidget<List<BoardClass>>(
              value: boardClassesAsync,
              onRetry: () => ref.invalidate(
                boardClassesForClassLevelProvider(selectedClassLevelId!),
              ),
              data: (leaves) {
                if (leaves.length <= 1) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: context.dimens.lg),
                    _SectionLabel(context.l10n.studentAcademicInfoGroupLabel),
                    SizedBox(height: context.dimens.sm),
                    for (final leaf in leaves) ...[
                      CatalogOptionRow(
                        label: leaf.name,
                        icon: _boardClassIcon(leaf.name),
                        isEnabled: leaf.isEnabled,
                        isSelected: leaf.id == selectedBoardClassId,
                        onTap: leaf.isEnabled
                            ? () => ref
                                .read(selectedBoardClassViewModelProvider.notifier)
                                .select(leaf.id)
                            : null,
                      ),
                      SizedBox(height: context.dimens.sm),
                    ],
                  ],
                );
              },
            ),
          if (selectedBoardClassId != null) ...[
            SizedBox(height: context.dimens.lg),
            _SectionLabel(context.l10n.subjectTeacherSelectTitle),
            SizedBox(height: context.dimens.sm),
            _SubjectsSection(boardClassId: selectedBoardClassId),
          ],
          SizedBox(height: context.dimens.xl),
          AppPrimaryButton(
            label: context.l10n.commonConfirm,
            onPressed: (selectedBoardClassId == null || selections.isEmpty)
                ? null
                : () {
                    final notifier =
                        ref.read(studentOnboardingViewModelProvider.notifier);
                    notifier.selectBoardClass(selectedBoardClassId);
                    notifier.replaceSubjectSelections(selections);
                    context.push(AppRoutes.studentOnboardingReview);
                  },
          ),
        ],
      ),
    );
  }
}

/// Distinct native icon per [ClassLevel] name — CLAUDE.md mandates native
/// Flutter icons over text-only class chips.
IconData _classLevelIcon(String name) {
  switch (name) {
    case '9th':
      return Icons.looks_one_outlined;
    case 'Matric':
      return Icons.school_outlined;
    case '1st year':
      return Icons.looks_two_outlined;
    case '2nd year':
      return Icons.filter_3_outlined;
    default:
      return Icons.class_outlined;
  }
}

/// Distinct native icon per [BoardClass] stream leaf name.
IconData _boardClassIcon(String name) {
  switch (name) {
    case 'Pre-Medical':
      return Icons.biotech_outlined;
    case 'Pre-Engineering':
      return Icons.engineering_outlined;
    case 'I.Com':
      return Icons.account_balance_outlined;
    case 'F.A':
      return Icons.palette_outlined;
    case 'I.C.S':
      return Icons.computer_outlined;
    default:
      return Icons.menu_book_outlined;
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyles.labelSmall?.copyWith(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Subjects + per-subject teacher picker for [boardClassId], scoped to the
/// campus chosen on `StudentBasicInfoView`. Mirrors the deleted
/// `SubjectTeacherSelectView`'s body exactly (including filtering teacher
/// options to `subjectIds.contains(subject.id)`), minus its own header/
/// button since this screen has one shared header and one shared Confirm.
class _SubjectsSection extends ConsumerWidget {
  const _SubjectsSection({required this.boardClassId});

  final String boardClassId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campusId =
        ref.watch(studentOnboardingViewModelProvider.notifier).campusId ?? '';
    final subjectsAsync = ref.watch(subjectsForBoardClassProvider(boardClassId));
    final teachersAsync = ref.watch(teachersForCampusProvider(campusId));
    final selections = ref.watch(subjectSelectionViewModelProvider);

    return AsyncValueWidget<List<Subject>>(
      value: subjectsAsync,
      onRetry: () => ref.invalidate(subjectsForBoardClassProvider(boardClassId)),
      data: (subjects) {
        if (subjects.isEmpty) {
          return EmptyStateView(
            message: context.l10n.subjectTeacherSelectNoSubjects,
          );
        }
        final teachers = teachersAsync.value ?? const <TeacherOption>[];
        return Column(
          children: [
            for (final subject in subjects) ...[
              Builder(
                builder: (context) {
                  final isSelected = selections.containsKey(subject.id);
                  final teachersForSubject = teachers
                      .where((t) => t.subjectIds.contains(subject.id))
                      .toList();
                  final assignedTeacherId = selections[subject.id];
                  final assignedTeacher = assignedTeacherId == null
                      ? null
                      : teachersForSubject
                          .where((t) => t.id == assignedTeacherId)
                          .firstOrNull;

                  return SubjectRow(
                    subjectName: subject.name,
                    isSelected: isSelected,
                    onSelectedChanged: (_) => ref
                        .read(subjectSelectionViewModelProvider.notifier)
                        .toggleSubject(subject.id),
                    discountApplied: assignedTeacherId != null,
                    teacherPicker: !isSelected
                        ? null
                        : teachersForSubject.isEmpty
                            ? Text(
                                context.l10n.subjectTeacherSelectNoTeachers,
                                style: context.textStyles.bodySmall?.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              )
                            : AppDropdown<TeacherOption>(
                                label: context.l10n.subjectTeacherSelectTeacherLabel,
                                items: teachersForSubject,
                                selectedItem: assignedTeacher,
                                itemAsString: (t) => t.name,
                                onChanged: (t) => ref
                                    .read(subjectSelectionViewModelProvider.notifier)
                                    .assignTeacher(subject.id, t?.id),
                              ),
                  );
                },
              ),
              SizedBox(height: context.dimens.sm),
            ],
          ],
        );
      },
    );
  }
}
