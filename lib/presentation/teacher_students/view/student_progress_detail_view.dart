import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart'
    show progressTestsByIdProvider;
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';
import '../viewmodel/student_progress_detail_viewmodel.dart';
import '../viewmodel/teacher_students_viewmodel.dart';
import '../widgets/attempts_list.dart';
import '../widgets/average_score_card.dart';

/// Detailed student diagnostic progress report screen.
/// Shows teacher-scoped enrolled subjects, overall score metrics, and attempt history.
class StudentProgressDetailView extends ConsumerWidget {
  const StudentProgressDetailView({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacher = ref.watch(currentTeacherProvider);
    final studentAsync = ref.watch(teacherViewedStudentProvider(studentId));
    final attemptsAsync = ref.watch(teacherStudentAttemptsProvider(studentId));

    final subjectsById =
        ref.watch(teacherStudentsSubjectsByIdProvider).value ??
        const <String, Subject>{};
    final campusesById =
        ref.watch(teacherStudentsCampusesByIdProvider).value ??
        const <String, Campus>{};

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Student Progress Report'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(teacherViewedStudentProvider(studentId));
              ref.invalidate(teacherStudentAttemptsProvider(studentId));
              ref.invalidate(progressTestsByIdProvider);
            },
            child: AsyncValueWidget<Student?>(
              value: studentAsync,
              onRetry:
                  () => ref.invalidate(teacherViewedStudentProvider(studentId)),
              data: (student) {
                if (student == null) {
                  return EmptyStateView(
                    message: context.l10n.studentProgressDetailEmpty,
                    icon: Icons.person_off_outlined,
                  );
                }

                // Scope enrolled subjects ONLY to this teacher
                final teacherScopedSubjects =
                    teacher == null
                        ? const <String>[]
                        : (student.subjectEnrollments ?? [])
                            .where((e) => e.teacherId == teacher.id)
                            .map(
                              (e) =>
                                  subjectsById[e.subjectId]?.name ??
                                  e.subjectId,
                            )
                            .toList();

                final isPaid = (student.subjectEnrollments ?? []).any(
                  (e) => e.discountApplied,
                );
                final campusName = campusesById[student.campusId]?.name;

                return AsyncValueWidget<List<TestAttempt>>(
                  value: attemptsAsync,
                  onRetry:
                      () => ref.invalidate(
                        teacherStudentAttemptsProvider(studentId),
                      ),
                  data: (attempts) {
                    return ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimens.lg,
                        vertical: context.dimens.md,
                      ),
                      children: [
                        // 1. Scoped Student Profile Header Card
                        _StudentHeaderCard(
                          student: student,
                          isPaid: isPaid,
                          campusName: campusName,
                          teacherScopedSubjects: teacherScopedSubjects,
                        ),
                        SizedBox(height: context.dimens.lg),

                        // 2. Score Summary & Performance Gauge
                        if (attempts.isNotEmpty) ...[
                          AverageScoreCard(
                            averagePercent: averageScorePercent(attempts),
                            attemptCount: attempts.length,
                          ),
                          SizedBox(height: context.dimens.xl),
                          Text(
                            context.l10n.progressAttempted,
                            style: context.textStyles.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.dimens.sm),
                          AttemptsList(attempts: attempts),
                        ] else ...[
                          AppFrostedCard(
                            padding: EdgeInsets.all(context.dimens.xl),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.hourglass_empty_rounded,
                                  size: 40,
                                  color: context.colors.textSecondary,
                                ),
                                SizedBox(height: context.dimens.sm),
                                Text(
                                  'No Test Attempts Yet',
                                  style: context.textStyles.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: context.dimens.xs),
                                Text(
                                  'This student has not submitted any chapter tests yet.',
                                  textAlign: TextAlign.center,
                                  style: context.textStyles.bodySmall?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: context.dimens.xl),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentHeaderCard extends StatelessWidget {
  const _StudentHeaderCard({
    required this.student,
    required this.isPaid,
    this.campusName,
    required this.teacherScopedSubjects,
  });

  final Student student;
  final bool isPaid;
  final String? campusName;
  final List<String> teacherScopedSubjects;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        isPaid ? const Color(0xFF059669) : const Color(0xFF64748B);
    final statusBg =
        isPaid
            ? const Color(0xFF059669).withValues(alpha: 0.1)
            : const Color(0xFF64748B).withValues(alpha: 0.1);
    final statusLabel = isPaid ? 'Active (Paid Bundle)' : 'Free (Unpaid)';

    return AppFrostedCard(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    isPaid
                        ? context.colors.primary.withValues(alpha: 0.15)
                        : context.colors.divider.withValues(alpha: 0.5),
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                  style: TextStyle(
                    color:
                        isPaid
                            ? context.colors.primary
                            : context.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: context.dimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: context.dimens.xs / 3),
                    Text(
                      student.phoneNumber,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.sm,
                  vertical: context.dimens.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(context.dimens.radiusLg),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),
          Divider(
            color: context.colors.divider.withValues(alpha: 0.5),
            height: 1,
          ),
          SizedBox(height: context.dimens.md),

          // Campus and Scoped Subject Info
          if (campusName != null) ...[
            Row(
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  size: 16,
                  color: context.colors.textSecondary,
                ),
                SizedBox(width: context.dimens.xs),
                Expanded(
                  child: Text(
                    campusName!,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimens.xs),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 16,
                color: context.colors.primary,
              ),
              SizedBox(width: context.dimens.xs),
              Expanded(
                child: Text(
                  'Enrolled with you in: ${teacherScopedSubjects.isNotEmpty ? teacherScopedSubjects.join(", ") : "General Enrolled"}',
                  style: context.textStyles.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
