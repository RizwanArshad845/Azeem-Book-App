import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart'
    show progressTestsByIdProvider;
import '../viewmodel/student_progress_detail_viewmodel.dart';
import '../widgets/attempts_list.dart';
import '../widgets/average_score_card.dart';

/// Per-student progress detail, pushed from the Students tab list
/// (`AppRoutes.teacherStudentProgressDetail`, parameterized by `:studentId`
/// — an outside-shell route, same classification as `test-taking`, since
/// this is a focused drill-down task, not a bottom-nav destination).
/// Read-only, no primary action (§10.1).
class StudentProgressDetailView extends ConsumerWidget {
  const StudentProgressDetailView({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(teacherViewedStudentProvider(studentId));
    final attemptsAsync = ref.watch(
      teacherStudentAttemptsProvider(studentId),
    );

    final title = studentAsync.value?.name ?? context.l10n.studentProgressDetailTitle;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(teacherViewedStudentProvider(studentId));
            ref.invalidate(teacherStudentAttemptsProvider(studentId));
            ref.invalidate(progressTestsByIdProvider);
          },
          child: AsyncValueWidget<List<TestAttempt>>(
            value: attemptsAsync,
            onRetry: () =>
                ref.invalidate(teacherStudentAttemptsProvider(studentId)),
            data: (attempts) {
              if (attempts.isEmpty) {
                return ListView(
                  padding: EdgeInsets.all(context.dimens.lg),
                  children: [
                    EmptyStateView(
                      message: context.l10n.studentProgressDetailEmpty,
                    ),
                  ],
                );
              }

              return ListView(
                padding: EdgeInsets.all(context.dimens.lg),
                children: [
                  AverageScoreCard(
                    averagePercent: averageScorePercent(attempts),
                    attemptCount: attempts.length,
                  ),
                  SizedBox(height: context.dimens.lg),
                  Text(context.l10n.progressAttempted, style: context.textStyles.titleMedium),
                  SizedBox(height: context.dimens.md),
                  AttemptsList(attempts: attempts),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
