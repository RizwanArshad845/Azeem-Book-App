import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/review_answer_card.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';

/// "Review Answers" bottom sheet (test_result reference): a scrollable list of
/// per-question [ReviewAnswerCard]s (status + marks + expandable solution) and
/// a Close button. Replaces the old inline results breakdown.
class ReviewAnswersSheet extends StatelessWidget {
  const ReviewAnswersSheet({
    super.key,
    required this.questions,
    required this.answers,
  });

  final List<Question> questions;
  final List<SubmissionAnswer> answers;

  static Future<void> show(
    BuildContext context, {
    required List<Question> questions,
    required List<SubmissionAnswer> answers,
  }) {
    return AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.reviewAnswersTitle,
      child: ReviewAnswersSheet(questions: questions, answers: answers),
    );
  }

  @override
  Widget build(BuildContext context) {
    final answersById = {for (final a in answers) a.questionId: a};

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < questions.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: context.dimens.sm),
            child: _card(context, i, questions[i], answersById[questions[i].id]),
          ),
        SizedBox(height: context.dimens.sm),
        AppOutlinedButton(
          label: context.l10n.commonClose,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    int index,
    Question question,
    SubmissionAnswer? answer,
  ) {
    final isCorrect = answer?.isCorrect == true;
    final marks = question.marks;
    final correctAnswer = question.type == QuestionType.mcq
        ? (question.options != null && question.correctOptionIndex != null
            ? question.options![question.correctOptionIndex!]
            : null)
        : question.expectedAnswer;

    return ReviewAnswerCard(
      index: index + 1,
      isCorrect: isCorrect,
      statusLabel: isCorrect
          ? context.l10n.statusCorrect
          : context.l10n.statusNeedsPractice,
      questionText: question.questionText,
      scoreLabel: '${isCorrect ? marks : 0}/$marks',
      correctAnswerLabel: context.l10n.reviewCorrectAnswerLabel,
      correctAnswer: correctAnswer,
      solutionLabel: context.l10n.testResultsSolutionLabel,
      solution: answer?.solutionExplanation ?? question.solutionExplanation,
    );
  }
}
