import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/attempt_question.dart';

part 'attempt_question_dto.freezed.dart';
part 'attempt_question_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of a question returned by
/// `POST /tests/{id}/start-attempt` — answer-key free, see the domain
/// [AttemptQuestion] doc comment.
@freezed
abstract class AttemptQuestionDto with _$AttemptQuestionDto {
  const AttemptQuestionDto._();

  const factory AttemptQuestionDto({
    required String id,
    required QuestionType type,
    required String questionText,
    List<String>? options,
    @Default(1) int marks,
  }) = _AttemptQuestionDto;

  factory AttemptQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$AttemptQuestionDtoFromJson(json);

  AttemptQuestion toDomain() => AttemptQuestion(
    id: id,
    type: type,
    questionText: questionText,
    options: options,
    marks: marks,
  );
}
