import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/review_answer_card.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';

/// "Review Answers" bottom sheet (test_result reference): a scrollable list of
/// per-question [ReviewAnswerCard]s (status + marks + expandable solution) and
/// a Close button. Each [SubmissionAnswer] is fully self-describing once
/// graded (question text, expected answer, marks), so no separate question
/// list is needed here. Presented as a standard graded result — no "AI"
/// framing shown to the student, matching how a board exam result reads.
class ReviewAnswersSheet extends StatelessWidget {
  const ReviewAnswersSheet({super.key, required this.answers});

  final List<SubmissionAnswer> answers;

  static Future<void> show(
    BuildContext context, {
    required List<SubmissionAnswer> answers,
  }) {
    return AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.reviewAnswersTitle,
      child: ReviewAnswersSheet(answers: answers),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < answers.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: context.dimens.sm),
            child: _card(context, i, answers[i]),
          ),
      ],
    );
  }

  Widget _card(BuildContext context, int index, SubmissionAnswer answer) {
    final isCorrect = answer.isCorrect == true;
    final marks = answer.possibleMarks ?? 0;
    final earned = answer.marksAwarded ?? 0;

    return ReviewAnswerCard(
      index: index + 1,
      isCorrect: isCorrect,
      statusLabel: isCorrect
          ? context.l10n.statusCorrect
          : context.l10n.statusNeedsPractice,
      questionText: answer.questionText ?? '',
      scoreLabel: '$earned/$marks',
      correctAnswerLabel: context.l10n.reviewCorrectAnswerLabel,
      // `expectedAnswer` covers short/long-answer questions; mcq questions
      // only get a `correctOptionIndex` back (no answer-key text) per
      // `FRONTEND_INTEGRATION.md` §6.6 — fall back to an option label.
      correctAnswer: answer.expectedAnswer ??
          (answer.correctOptionIndex != null
              ? 'Option ${answer.correctOptionIndex! + 1}'
              : null),
      solutionLabel: context.l10n.testResultsSolutionLabel,
      solution: answer.justification ?? answer.solutionExplanation,
    );
  }
}
