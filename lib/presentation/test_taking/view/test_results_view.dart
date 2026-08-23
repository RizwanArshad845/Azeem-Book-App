import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../viewmodel/test_taking_viewmodel.dart';

/// Rendered by `TestTakingView` once `TestTakingState.status ==
/// TestTakingStatus.submitted` (no separate route — the submission result
/// is only ever reachable from having just finished this test, so it's
/// rendered in place rather than adding a new `AppRoutes` entry).
class TestResultsView extends ConsumerWidget {
  const TestResultsView({
    super.key,
    required this.testId,
    required this.attempt,
    required this.questions,
  });

  final String testId;
  final TestAttempt attempt;

  /// The test's questions, kept alive in `TestTakingState` from before
  /// submission — used here to resolve question text for the per-question
  /// breakdown (`TestAttempt.answers` only carries `questionId`).
  final List<Question> questions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreColor = attempt.scorePercent >= 75
        ? context.colors.success
        : attempt.scorePercent >= 50
        ? context.colors.warning
        : context.colors.error;

    final answersByQuestionId = {
      for (final answer in attempt.answers) answer.questionId: answer,
    };

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          context.l10n.testResultsScore,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: context.dimens.sm),
                        Text(
                          '${attempt.scorePercent.toStringAsFixed(0)}%',
                          style: context.textStyles.headlineMedium?.copyWith(
                            color: scoreColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.dimens.lg),
                  if ((attempt.strongChapterIds ?? const []).isNotEmpty) ...[
                    Text(
                      context.l10n.testResultsStrongChapters,
                      style: context.textStyles.titleMedium,
                    ),
                    SizedBox(height: context.dimens.sm),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final id in attempt.strongChapterIds!)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.dimens.xs / 2,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: context.colors.success,
                                    size: context.dimens.iconSm,
                                  ),
                                  SizedBox(width: context.dimens.sm),
                                  Expanded(child: Text(id)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),
                  ],
                  if ((attempt.weakChapterIds ?? const []).isNotEmpty) ...[
                    Text(
                      context.l10n.testResultsWeakChapters,
                      style: context.textStyles.titleMedium,
                    ),
                    SizedBox(height: context.dimens.sm),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final id in attempt.weakChapterIds!)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.dimens.xs / 2,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.trending_down,
                                    color: context.colors.error,
                                    size: context.dimens.iconSm,
                                  ),
                                  SizedBox(width: context.dimens.sm),
                                  Expanded(child: Text(id)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),
                  ],
                  if (questions.isNotEmpty) ...[
                    Text(
                      context.l10n.testResultsBreakdownTitle,
                      style: context.textStyles.titleMedium,
                    ),
                    SizedBox(height: context.dimens.sm),
                    for (var i = 0; i < questions.length; i++)
                      _QuestionBreakdownCard(
                        index: i,
                        question: questions[i],
                        answer: answersByQuestionId[questions[i].id],
                      ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.dimens.md),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    label: context.l10n.resultsReturnHome,
                    onPressed: () => context.go(AppRoutes.studentHome),
                  ),
                ),
                SizedBox(width: context.dimens.md),
                Expanded(
                  child: AppPrimaryButton(
                    label: context.l10n.testResultsReattemptButton,
                    onPressed: () {
                      // Re-triggers TestTakingViewModel.build(), which
                      // starts a brand-new attempt for the same test — it
                      // submits through the same SubmitTestAttemptUseCase
                      // and gets its own fresh weak/strong chapters and
                      // score, no special-casing needed here.
                      ref.invalidate(testTakingViewModelProvider(testId));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One question's row in the results breakdown: check/cancel icon per
/// correctness (Workstream 6), and — for wrong answers only — a visually
/// separated "solution" block rendering `Question.solutionExplanation`
/// (carried onto the graded `SubmissionAnswer` by the grading use cases).
class _QuestionBreakdownCard extends StatelessWidget {
  const _QuestionBreakdownCard({
    required this.index,
    required this.question,
    required this.answer,
  });

  final int index;
  final Question question;
  final SubmissionAnswer? answer;

  @override
  Widget build(BuildContext context) {
    final isCorrect = answer?.isCorrect == true;
    final String? explanation = answer?.solutionExplanation;

    return Padding(
      padding: EdgeInsets.only(bottom: context.dimens.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect
                      ? context.colors.success
                      : context.colors.error,
                  size: context.dimens.iconSm,
                ),
                SizedBox(width: context.dimens.sm),
                Expanded(
                  child: Text(
                    'Q${index + 1}. ${question.questionText}',
                    style: context.textStyles.bodyMedium,
                  ),
                ),
              ],
            ),
            if (!isCorrect && explanation != null && explanation.isNotEmpty) ...[
              SizedBox(height: context.dimens.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.dimens.sm),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: context.colors.secondary,
                      size: context.dimens.iconSm,
                    ),
                    SizedBox(width: context.dimens.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.testResultsSolutionLabel,
                            style: context.textStyles.labelMedium?.copyWith(
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.dimens.xs / 2),
                          Text(explanation, style: context.textStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
