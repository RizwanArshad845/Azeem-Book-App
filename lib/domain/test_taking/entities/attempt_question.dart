import 'package:freezed_annotation/freezed_annotation.dart';

import '../../catalog/entities/question.dart';

part 'attempt_question.freezed.dart';

/// A question as handed to the student for an in-progress attempt —
/// deliberately carries no answer key (`correctOptionIndex`/`expectedAnswer`,
/// present on the catalog [Question] entity): the server keeps grading keys
/// secret until the attempt is graded, per `POST /tests/{id}/start-attempt`.
@freezed
abstract class AttemptQuestion with _$AttemptQuestion {
  const factory AttemptQuestion({
    required String id,
    required QuestionType type,
    required String questionText,
    List<String>? options,
    @Default(1) int marks,
  }) = _AttemptQuestion;
}
