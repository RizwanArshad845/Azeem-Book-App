import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';

/// `type` of a [Question] (project_spec.md §9.2).
enum QuestionType { mcq, shortAnswer, longAnswer }

/// Belongs to a [Test] and a `Chapter` (via `chapterId`). MCQs carry
/// `options` + `correctOptionIndex`; short/long carry an `expectedAnswer`
/// used by AI-driven grading (project_spec.md §9.2). `solutionExplanation`
/// is a property of the question itself (not the student's answer) — it's
/// carried into a graded [SubmissionAnswer] by the grading use cases so the
/// results screen can show it for wrong answers.
@freezed
abstract class Question with _$Question {
  const factory Question({
    required String id,
    required String testId,
    required String chapterId,
    required QuestionType type,
    required String questionText,
    List<String>? options,
    int? correctOptionIndex,
    String? expectedAnswer,
    String? solutionExplanation,
  }) = _Question;
}
