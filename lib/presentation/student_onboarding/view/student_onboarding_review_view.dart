import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/onboarding_icon_pattern_background.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../core/widgets/onboarding_summary_item.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';

/// Final onboarding step — shows everything collected across the basic-info
/// and academic-info steps for the student to double-check (and fix a typo
/// in their name or campus) before a "Submit" finalizes registration.
/// Placed here (after the forms, not right after OTP) because this is the
/// first point where a full profile actually exists to review.
class StudentOnboardingReviewView extends ConsumerStatefulWidget {
  const StudentOnboardingReviewView({super.key});

  @override
  ConsumerState<StudentOnboardingReviewView> createState() =>
      _StudentOnboardingReviewViewState();
}

class _StudentOnboardingReviewViewState
    extends ConsumerState<StudentOnboardingReviewView> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(studentOnboardingViewModelProvider.notifier);
    _nameController = TextEditingController(text: notifier.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(studentOnboardingViewModelProvider.notifier);
    final onboardingState = ref.watch(studentOnboardingViewModelProvider);
    final campusId = notifier.campusId;
    final boardClassId = notifier.boardClassId;
    final selectedSubjectIds = notifier.selectedSubjectIds;
    final teacherIdBySubjectId = notifier.teacherIdBySubjectId;

    final campusesAsync = ref.watch(campusesProvider);
    final subjectsAsync = boardClassId != null
        ? ref.watch(subjectsForBoardClassProvider(boardClassId))
        : null;
    final teachersAsync =
        campusId != null ? ref.watch(teachersForCampusProvider(campusId)) : null;

    ref.listen<AsyncValue<dynamic>>(studentOnboardingViewModelProvider, (
      previous,
      next,
    ) {
      final error = next.error;
      if (error != null) {
        final message = error is Failure ? error.message : error.toString();
        AppSnackbar.show(context, message);
      }
    });

    final selectedCampus = campusesAsync.value
        ?.where((c) => c.id == campusId)
        .firstOrNull;

    return OnboardingScaffold(
      appBarTitle: context.l10n.onboardingReviewTitle,
      role: OnboardingRole.student,
      onBack: () => context.pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.onboardingReviewHeadline,
            subtitle: context.l10n.onboardingReviewSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          AppTextField(
            label: context.l10n.nameLabel,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            isRequired: true,
            onChanged: notifier.recordName,
          ),
          SizedBox(height: context.dimens.lg),
          AppDropdownCard<Campus>(
            label: context.l10n.campusLabel,
            items: campusesAsync.value ?? const <Campus>[],
            selectedItem: selectedCampus,
            isRequired: true,
            icon: Icons.location_city_rounded,
            itemAsString: (c) => '${c.name} (${c.city})',
            onChanged: (campus) {
              if (campus != null) notifier.selectCampus(campus.id);
            },
          ),
          if (selectedSubjectIds.isNotEmpty) ...[
            SizedBox(height: context.dimens.lg),
            _SectionLabel(context.l10n.subjectSelectionTitle),
            SizedBox(height: context.dimens.sm),
            OnboardingSummaryList(
              children: [
                for (final subjectId in selectedSubjectIds)
                  _SubjectSummaryItem(
                    subjectId: subjectId,
                    teacherId: teacherIdBySubjectId[subjectId],
                    subjects: subjectsAsync?.value,
                    teachers: teachersAsync?.value,
                  ),
              ],
            ),
          ],
          SizedBox(height: context.dimens.xl),
          AppPrimaryButton(
            label: context.l10n.commonSubmit,
            loading: onboardingState.isLoading,
            onPressed: () => notifier.submit(),
          ),
        ],
      ),
    );
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

class _SubjectSummaryItem extends StatelessWidget {
  const _SubjectSummaryItem({
    required this.subjectId,
    required this.teacherId,
    required this.subjects,
    required this.teachers,
  });

  final String subjectId;
  final String? teacherId;
  final List<Subject>? subjects;
  final List<TeacherOption>? teachers;

  @override
  Widget build(BuildContext context) {
    final subjectName =
        subjects?.where((s) => s.id == subjectId).firstOrNull?.name ?? subjectId;
    final teacherName = teacherId == null
        ? context.l10n.onboardingReviewNoTeacher
        : teachers?.where((t) => t.id == teacherId).firstOrNull?.name ??
            context.l10n.onboardingReviewNoTeacher;

    return OnboardingSummaryItem(
      icon: subjectIcon(subjectName),
      label: context.l10n.localizedSubjectName(subjectName),
      value: teacherName,
      isMuted: teacherId == null,
    );
  }
}
