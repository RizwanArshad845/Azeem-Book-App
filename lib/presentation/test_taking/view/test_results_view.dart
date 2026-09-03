import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/section_breakdown_card.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/compute_section_breakdown.dart';
import '../viewmodel/free_attempts_provider.dart';
import '../viewmodel/test_taking_viewmodel.dart';
import '../widgets/review_answers_sheet.dart';

/// Rendered by `TestTakingView` once the attempt is submitted. Redesigned to
/// the test_result reference: a score hero (X/total + %), a 3-up stats row
/// (Correct / Wrong / Time), a per-section marks breakdown, and Review /
/// Reattempt / Back actions. Reattempt is gated by the global free-attempts
/// limit. Sourced entirely from [attempt] — each graded `SubmissionAnswer`
/// is now self-describing (question text/type/marks), so no separate
/// question list needs to be fetched to render a result.
class TestResultsView extends ConsumerWidget {
  const TestResultsView({
    super.key,
    required this.testId,
    required this.attempt,
    this.isOwned = false,
    this.isHistoricalView = false,
  });

  final String testId;
  final TestAttempt attempt;

  /// Whether the test's subject has been purchased — exempts it from the
  /// global free-attempts exhaustion gate on Reattempt.
  final bool isOwned;

  /// True when viewing a past attempt (e.g. from the Progress tab) rather
  /// than right after submitting — hides Reattempt/Go-Home, showing only
  /// Review Answers.
  final bool isHistoricalView;

  String _sectionTitle(BuildContext context, int number, QuestionType type) {
    final label = switch (type) {
      QuestionType.mcq => context.l10n.sectionTypeMcq,
      QuestionType.shortAnswer => context.l10n.sectionTypeShort,
      QuestionType.longAnswer => context.l10n.sectionTypeLong,
    };
    return 'Q$number $label';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = computeSectionBreakdown(attempt.answers);
    final earned = sections.fold<int>(0, (s, x) => s + x.earnedMarks);
    final total = sections.fold<int>(0, (s, x) => s + x.totalMarks);
    final correct = sections.fold<int>(0, (s, x) => s + x.correct);
    final wrong = sections.fold<int>(0, (s, x) => s + x.wrong);
    final percent = total == 0 ? 0 : (earned / total * 100).round();
    final minutes = ((attempt.durationSeconds ?? 0) / 60).round();

    final scoreColor = percent >= 75
        ? context.colors.success
        : percent >= 50
            ? context.colors.warning
            : context.colors.error;

    final exhausted = !isOwned && ref.watch(attemptsExhaustedProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _ScoreHero(
                    earned: earned,
                    total: total,
                    percent: percent,
                    color: scoreColor,
                  ),
                  SizedBox(height: context.dimens.md),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: Icons.check_circle_outline,
                          value: '$correct',
                          label: context.l10n.scoreCorrect,
                          color: context.colors.success,
                        ),
                      ),
                      SizedBox(width: context.dimens.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.cancel_outlined,
                          value: '$wrong',
                          label: context.l10n.scoreWrong,
                          color: context.colors.error,
                        ),
                      ),
                      SizedBox(width: context.dimens.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.timer_outlined,
                          value: context.l10n.scoreTimeValue(minutes),
                          label: context.l10n.scoreTimeTaken,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  if (sections.isNotEmpty) ...[
                    SizedBox(height: context.dimens.lg),
                    Text(
                      context.l10n.sectionBreakdownTitle,
                      style: context.textStyles.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: context.dimens.sm),
                    for (var i = 0; i < sections.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: context.dimens.sm),
                        child: SectionBreakdownCard(
                          title: _sectionTitle(context, i + 1, sections[i].type),
                          correct: sections[i].correct,
                          wrong: sections[i].wrong,
                          earnedMarks: sections[i].earnedMarks,
                          totalMarks: sections[i].totalMarks,
                        ),
                      ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.dimens.sm),
            AppPrimaryButton(
              label: context.l10n.reviewAnswersButton,
              icon: Icons.fact_check_outlined,
              onPressed: () => ReviewAnswersSheet.show(
                context,
                answers: attempt.answers,
              ),
            ),
            if (!isHistoricalView) ...[
              SizedBox(height: context.dimens.sm),
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      label: context.l10n.testResultsReattemptButton,
                      onPressed: () {
                        if (exhausted) {
                          AppSnackbar.show(
                            context,
                            context.l10n.attemptsBlockedMessage,
                          );
                          return;
                        }
                        ref.invalidate(testTakingViewModelProvider(testId));
                      },
                    ),
                  ),
                  SizedBox(width: context.dimens.md),
                  Expanded(
                    child: AppOutlinedButton(
                      label: context.l10n.resultsReturnHome,
                      onPressed: () => context.go(AppRoutes.studentHome),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreHero extends StatelessWidget {
  const _ScoreHero({
    required this.earned,
    required this.total,
    required this.percent,
    required this.color,
  });

  final int earned;
  final int total;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.testResultsScore,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.dimens.xs),
                Text(
                  '$earned/$total',
                  style: context.textStyles.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$percent%',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(context.dimens.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusLg),
            ),
            child: Icon(
              Icons.emoji_events,
              color: color,
              size: context.dimens.iconLg,
            ),
          ),
        ],
      ),
    );
  }
}
