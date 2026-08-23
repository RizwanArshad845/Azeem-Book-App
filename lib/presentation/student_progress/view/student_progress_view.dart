import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dropdown_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../test_taking/view/test_results_view.dart';
import '../viewmodel/student_progress_viewmodel.dart';
import '../widgets/chapter_progress_pie_chart.dart';
import '../widgets/overall_mastery_card.dart';

/// Student Progress screen (§10.2 / Phase G): Dynamic subject filter,
/// dynamic attempt filter, overall mastery card, chapter progress pie chart,
/// per-chapter breakdown cards, and re-using TestResultsView on chapter tap.
class StudentProgressView extends ConsumerWidget {
  const StudentProgressView({super.key});

  Future<void> _openChapterResult(
    BuildContext context,
    ChapterProgressData chapter,
  ) async {
    if (chapter.latestAttempt == null) return;

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
        chapterTitle: chapter.chapterTitle,
        testId: chapter.testId,
        attempt: chapter.latestAttempt!,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attemptsAsync = ref.watch(studentTestAttemptsProvider);
    final masteryAsync = ref.watch(filteredOverallMasteryProvider);
    final summaryAsync = ref.watch(filteredChapterProgressSummaryProvider);
    final subjectsAsync = ref.watch(perSubjectProgressProvider);
    final chaptersAsync = ref.watch(filteredChapterProgressListProvider);
    final availableFiltersAsync = ref.watch(availableAttemptFiltersProvider);

    final selectedSubjectId = ref.watch(selectedProgressSubjectProvider);
    final selectedAttemptFilter =
        ref.watch(selectedProgressAttemptFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(studentTestAttemptsProvider);
            ref.invalidate(progressTestsByIdProvider);
            ref.invalidate(perSubjectProgressProvider);
            ref.invalidate(filteredAttemptsProvider);
            ref.invalidate(availableAttemptFiltersProvider);
            ref.invalidate(filteredOverallMasteryProvider);
            ref.invalidate(filteredChapterProgressSummaryProvider);
            ref.invalidate(filteredChapterProgressListProvider);
          },
          child: AsyncValueWidget<List<TestAttempt>>(
            value: attemptsAsync,
            skeleton: const Padding(
              padding: EdgeInsets.all(16),
              child: SkeletonList(itemCount: 4),
            ),
            onRetry: () => ref.invalidate(studentTestAttemptsProvider),
            data: (attempts) {
              if (attempts.isEmpty) {
                return ListView(
                  padding: EdgeInsets.all(context.dimens.lg),
                  children: [
                    EmptyStateView(message: context.l10n.progressEmpty),
                  ],
                );
              }

              final subjectSummaries = subjectsAsync.value ?? const [];
              final availableFilters =
                  availableFiltersAsync.value ?? const ['all'];

              final mastery = masteryAsync.value ??
                  const OverallMasteryData(
                    masteryPercent: 0,
                    testsAttempted: 0,
                  );

              final summary =
                  summaryAsync.value ?? ChapterProgressSummary.empty;
              final chapterList = chaptersAsync.value ?? const [];

              return ListView(
                padding: EdgeInsets.all(context.dimens.lg),
                children: [
                  OverallMasteryCard(
                    masteryPercent: mastery.masteryPercent,
                    testsAttempted: mastery.testsAttempted,
                  ),
                  SizedBox(height: context.dimens.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppDropdownCard<String>(
                          label: context.l10n.progressSubjectFilterLabel,
                          items: [
                            'all',
                            for (final s in subjectSummaries) s.subjectId,
                          ],
                          selectedItem: selectedSubjectId,
                          itemAsString: (id) {
                            if (id == 'all') {
                              return context.l10n.progressAllSubjects;
                            }
                            final matched = subjectSummaries
                                .where((s) => s.subjectId == id)
                                .firstOrNull;
                            return matched?.subjectName ?? id;
                          },
                          icon: Icons.menu_book_outlined,
                          onChanged: (val) {
                            if (val != null) {
                              ref
                                  .read(
                                    selectedProgressSubjectProvider.notifier,
                                  )
                                  .setSubjectId(val);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: context.dimens.sm),
                      Expanded(
                        child: AppDropdownCard<String>(
                          label: context.l10n.progressAttemptFilterLabel,
                          items: availableFilters,
                          selectedItem: selectedAttemptFilter,
                          itemAsString: (filterKey) {
                            if (filterKey == 'all') {
                              return context.l10n.progressAllAttempts;
                            }
                            if (filterKey == 'latest') {
                              return context.l10n.progressLatestAttempt;
                            }
                            final n = int.tryParse(filterKey);
                            if (n != null) {
                              return context.l10n.attemptNumberLabel(n);
                            }
                            return filterKey;
                          },
                          icon: Icons.repeat_rounded,
                          onChanged: (val) {
                            if (val != null) {
                              ref
                                  .read(
                                    selectedProgressAttemptFilterProvider
                                        .notifier,
                                  )
                                  .setFilter(val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.dimens.md),
                  if (summary.total > 0) ...[
                    ChapterProgressPieChart(summary: summary),
                    SizedBox(height: context.dimens.lg),
                  ],
                  Text(
                    context.l10n.progressChapterProgressTitle,
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.dimens.sm),
                  if (chapterList.isEmpty)
                    EmptyStateView(
                      message: context.l10n.progressNoChaptersFound,
                    )
                  else
                    for (final chapter in chapterList) ...[
                      Padding(
                        padding: EdgeInsets.only(bottom: context.dimens.sm),
                        child: _ChapterProgressCard(
                          chapter: chapter,
                          onTap: () => _openChapterResult(context, chapter),
                        ),
                      ),
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
              Text(
                chapter.attemptsCount == 1
                    ? context.l10n.progressAttemptSingular
                    : context.l10n.progressAttemptPlural(chapter.attemptsCount),
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              Row(
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

/// Modal sheet that loads questions for the tapped chapter test and renders
/// the exact same [TestResultsView] widget used after submitting a test.
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
    final questionsAsync = ref.watch(chapterQuestionsProvider(testId));

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
            child: AsyncValueWidget<List<Question>>(
              value: questionsAsync,
              onRetry: () => ref.invalidate(chapterQuestionsProvider(testId)),
              data: (questions) => TestResultsView(
                testId: testId,
                attempt: attempt,
                questions: questions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
