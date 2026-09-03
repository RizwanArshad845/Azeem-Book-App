import 'package:freezed_annotation/freezed_annotation.dart';

import '../../catalog/entities/question.dart';
import 'token_judgement.dart';

part 'submission_answer.freezed.dart';

/// A single answer within a [TestAttempt] (project_spec.md §9.2
/// `SubmissionAnswer`). `selectedOptionIndex` is populated for mcq
/// questions, `answerText` for short/long-answer questions while the
/// attempt is still [inProgress][TestAttemptStatus.inProgress].
///
/// Once graded, the server fills in the rest — `questionText`/`type`/
/// `expectedAnswer`/`marksAwarded`/`possibleMarks`/`justification`/
/// `tokenJudgements` — so this entity is fully self-describing for the
/// results/review screens without needing the original question list
/// cross-referenced by id.
@freezed
abstract class SubmissionAnswer with _$SubmissionAnswer {
  const SubmissionAnswer._();

  const factory SubmissionAnswer({
    required String questionId,
    QuestionType? type,
    String? questionText,
    String? answerText,
    int? selectedOptionIndex,
    String? expectedAnswer,
    int? marksAwarded,
    int? possibleMarks,
    List<TokenJudgement>? tokenJudgements,
    String? justification,
    String? solutionExplanation,
    @Default(false) bool gradedByAi,
  }) = _SubmissionAnswer;

  /// `null` until graded (both `marksAwarded`/`possibleMarks` are set by the
  /// server only once grading completes).
  bool? get isCorrect => marksAwarded != null && possibleMarks != null
      ? marksAwarded! >= possibleMarks!
      : null;
}
