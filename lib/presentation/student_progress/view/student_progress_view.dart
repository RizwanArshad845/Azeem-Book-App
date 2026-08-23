import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../viewmodel/student_progress_viewmodel.dart';
import '../widgets/chapter_summary_section.dart';
import '../widgets/overall_mastery_card.dart';
import '../widgets/progress_view_mode_toggle.dart';
import '../widgets/student_attempts_list.dart';
import '../widgets/subject_progress_list.dart';

/// Student shell Progress tab root (§10.2: "Attempted tests list, overall
/// progress, per-test report (pie chart)"). Read-only — no primary action
/// on this screen per §10.1 (nothing here is created/edited, only reviewed).
class StudentProgressView extends ConsumerWidget {
  const StudentProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attemptsAsync = ref.watch(studentTestAttemptsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(studentTestAttemptsProvider);
            ref.invalidate(progressTestsByIdProvider);
            ref.invalidate(chapterProgressSummaryProvider);
            ref.invalidate(perSubjectProgressProvider);
          },
          child: AsyncValueWidget<List<TestAttempt>>(
            value: attemptsAsync,
            onRetry: () => ref.invalidate(studentTestAttemptsProvider),
            data: (attempts) {
              if (attempts.isEmpty) {
                return ListView(
                  padding: EdgeInsets.all(context.dimens.lg),
                  children: [
                    EmptyStateView(
                      message: context.l10n.progressEmpty,
                    ),
                  ],
                );
              }

              final mode = ref.watch(progressViewModeProvider);
              final averageScorePercent =
                  attempts.map((a) => a.scorePercent).reduce((a, b) => a + b) /
                  attempts.length;

              return ListView(
                padding: EdgeInsets.all(context.dimens.lg),
                children: [
                  OverallMasteryCard(
                    masteryPercent: averageScorePercent,
                    testsAttempted: attempts.length,
                  ),
                  SizedBox(height: context.dimens.lg),
                  const ProgressViewModeToggle(),
                  SizedBox(height: context.dimens.lg),
                  if (mode == ProgressViewMode.overall) ...[
                    const ChapterSummarySection(),
                    SizedBox(height: context.dimens.lg),
                    Text(context.l10n.progressAttempted, style: context.textStyles.titleMedium),
                    SizedBox(height: context.dimens.md),
                    StudentAttemptsList(attempts: attempts),
                  ] else
                    const SubjectProgressList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
