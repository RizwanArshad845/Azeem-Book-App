import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';

/// `type` of a [Question] (project_spec.md §9.2).
enum QuestionType { mcq, shortAnswer, longAnswer }

/// Belongs to a [Test] and a `Chapter` (via `chapterId`). MCQs carry
/// `options` + `correctOptionIndex`; short/long carry an `expectedAnswer`
/// used by AI-driven grading (project_spec.md §9.2).
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
  }) = _Question;
}
