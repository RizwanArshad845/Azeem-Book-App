import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../test_taking/view/test_results_view.dart';
import '../viewmodel/student_progress_viewmodel.dart';
import '../widgets/attempt_card.dart';
import '../widgets/chapter_progress_pie_chart.dart';
import '../widgets/overall_mastery_card.dart';
import '../widgets/progress_view_mode_toggle.dart';
import '../widgets/subject_progress_list.dart';

/// Student Progress screen (§10.2 / Phase G): an Overall | By subject
/// toggle. Overall shows the mastery card, chapter progress pie chart,
/// per-chapter breakdown cards and recent attempts; By subject shows one
/// card per subject. Tapping a chapter or attempt re-uses TestResultsView.
class StudentProgressView extends ConsumerWidget {
  const StudentProgressView({super.key});

  Future<void> _openResult(
    BuildContext context, {
    required String title,
    required String testId,
    required TestAttempt attempt,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimens.radiusLg),
        ),
      ),
      builder: (ctx) => _ChapterResultSheet(
        chapterTitle: title,
        testId: testId,
        attempt: attempt,
      ),
    );
  }

  Future<void> _openChapterResult(
    BuildContext context,
    ChapterProgressData chapter,
  ) async {
    final attempt = chapter.latestAttempt;
    if (attempt == null) return;
    await _openResult(
      context,
      title: chapter.chapterTitle,
      testId: chapter.testId,
      attempt: attempt,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attemptsAsync = ref.watch(gradedStudentAttemptsProvider);
    final masteryAsync = ref.watch(filteredOverallMasteryProvider);
    final summaryAsync = ref.watch(filteredChapterProgressSummaryProvider);
    final chaptersAsync = ref.watch(filteredChapterProgressListProvider);
    final testsById = ref.watch(progressTestsByIdProvider).value ?? const {};
    final mode = ref.watch(progressViewModeProvider);

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.progressTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(studentTestAttemptsProvider);
            ref.invalidate(gradedStudentAttemptsProvider);
            ref.invalidate(progressTestsByIdProvider);
            ref.invalidate(perSubjectProgressProvider);
            ref.invalidate(filteredAttemptsProvider);
            ref.invalidate(filteredOverallMasteryProvider);
            ref.invalidate(filteredChapterProgressSummaryProvider);
            ref.invalidate(filteredChapterProgressListProvider);
          },
          child: AsyncValueWidget<List<TestAttempt>>(
            value: attemptsAsync,
            skeleton: Padding(
              padding: EdgeInsets.all(context.dimens.lg),
              child: const SkeletonList(itemCount: 4),
            ),
            onRetry: () {
              ref.invalidate(studentTestAttemptsProvider);
              ref.invalidate(gradedStudentAttemptsProvider);
            },
            data: (attempts) {
              if (attempts.isEmpty) {
                return LayoutBuilder(
                  builder:
                      (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: EmptyStateView(
                            icon: Icons.insights_rounded,
                            message: context.l10n.progressEmpty,
                            actionLabel: context.l10n.stuTakeATest,
                            onAction: () => context.go(AppRoutes.studentHome),
                          ),
                        ),
                      ),
                );
              }

              final mastery = masteryAsync.value ??
                  const OverallMasteryData(
                    masteryPercent: 0,
                    testsAttempted: 0,
                  );

              final summary =
                  summaryAsync.value ?? ChapterProgressSummary.empty;
              final chapterList = chaptersAsync.value ?? const [];
              // Graded attempts arrive newest first.
              final recentAttempts = attempts.take(3).toList();
              final sectionTitleStyle = context.textStyles.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700);

              return ListView(
                padding: EdgeInsets.all(context.dimens.lg),
                children: [
                  const ProgressViewModeToggle(),
                  SizedBox(height: context.dimens.md),
                  if (mode == ProgressViewMode.perSubject)
                    const SubjectProgressList()
                  else ...[
                    FadeSlideIn(
                      child: OverallMasteryCard(
                        masteryPercent: mastery.masteryPercent,
                        testsAttempted: mastery.testsAttempted,
                      ),
                    ),
                    SizedBox(height: context.dimens.md),
                    if (summary.total > 0) ...[
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 80),
                        child: ChapterProgressPieChart(summary: summary),
                      ),
                      SizedBox(height: context.dimens.lg),
                    ],
                    Text(
                      context.l10n.progressChapterProgressTitle,
                      style: sectionTitleStyle,
                    ),
                    SizedBox(height: context.dimens.sm),
                    if (chapterList.isEmpty)
                      EmptyStateView(
                        message: context.l10n.progressNoChaptersFound,
                      )
                    else
                      for (final (i, chapter) in chapterList.indexed)
                        Padding(
                          padding: EdgeInsets.only(bottom: context.dimens.sm),
                          child: FadeSlideIn(
                            delay: Duration(milliseconds: 40 * i.clamp(0, 8)),
                            child: _ChapterProgressCard(
                              chapter: chapter,
                              onTap: () => _openChapterResult(context, chapter),
                            ),
                          ),
                        ),
                    if (recentAttempts.isNotEmpty) ...[
                      SizedBox(height: context.dimens.md),
                      Text(
                        context.l10n.stuRecentAttempts,
                        style: sectionTitleStyle,
                      ),
                      SizedBox(height: context.dimens.sm),
                      for (final attempt in recentAttempts)
                        Padding(
                          padding: EdgeInsets.only(bottom: context.dimens.sm),
                          child: AttemptCard(
                            attempt: attempt,
                            testTitle: testsById[attempt.testId]?.title ??
                                context.l10n.testTakingTitle,
                            onTap: () => _openResult(
                              context,
                              title: testsById[attempt.testId]?.title ??
                                  context.l10n.testTakingTitle,
                              testId: attempt.testId,
                              attempt: attempt,
                            ),
                          ),
                        ),
                    ],
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChapterProgressCard extends StatelessWidget {
  const _ChapterProgressCard({required this.chapter, required this.onTap});

  final ChapterProgressData chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percent = chapter.averagePercent.round();
    final badgeColor = percent >= 75
        ? context.colors.success
        : percent >= 50
            ? context.colors.warning
            : context.colors.error;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chapter.chapterTitle,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusBadge(
                label: '$percent%',
                color: badgeColor,
              ),
            ],
          ),
          SizedBox(height: context.dimens.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(context.dimens.pillRadius),
            child: LinearProgressIndicator(
              value: percent / 100.0,
              backgroundColor: context.colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
              minHeight: 6,
            ),
          ),
          SizedBox(height: context.dimens.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chapter.attemptsCount == 1
                      ? context.l10n.progressAttemptSingular
                      : context.l10n.progressAttemptPlural(chapter.attemptsCount),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: context.dimens.sm),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.progressViewResult,
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: context.dimens.iconSm,
                    color: context.colors.primary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Modal sheet rendering the exact same [TestResultsView] widget used after
/// submitting a test — the graded [attempt] is now fully self-describing
/// (each answer carries its own question text/marks/AI-grading detail), so
/// no separate questions fetch is needed to show a past result.
class _ChapterResultSheet extends ConsumerWidget {
  const _ChapterResultSheet({
    required this.chapterTitle,
    required this.testId,
    required this.attempt,
  });

  final String chapterTitle;
  final String testId;
  final TestAttempt attempt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FractionallySizedBox(
      heightFactor: 0.90,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.lg,
              vertical: context.dimens.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    chapterTitle,
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: context.l10n.commonClose,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TestResultsView(
              testId: testId,
              attempt: attempt,
              isHistoricalView: true,
            ),
          ),
        ],
      ),
    );
  }
}
