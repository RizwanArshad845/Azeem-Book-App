import 'package:freezed_annotation/freezed_annotation.dart';

part 'submission_answer.freezed.dart';

/// A single graded/ungraded answer within a [TestAttempt] (project_spec.md
/// §9.2 `SubmissionAnswer`). `selectedOptionIndex` is populated for mcq
/// questions, `answerText` for short/long-answer questions. `isCorrect` is
/// `null` only in the (currently unused) case a question couldn't be graded
/// at all; every question type handled by this feature always produces a
/// definite `true`/`false`.
@freezed
abstract class SubmissionAnswer with _$SubmissionAnswer {
  const factory SubmissionAnswer({
    required String questionId,
    String? answerText,
    int? selectedOptionIndex,
    bool? isCorrect,
    @Default(false) bool gradedByAi,
    String? solutionExplanation,
  }) = _SubmissionAnswer;
}
