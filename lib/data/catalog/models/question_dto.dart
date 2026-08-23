import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/question.dart';

part 'question_dto.freezed.dart';
part 'question_dto.g.dart';

@freezed
abstract class QuestionDto with _$QuestionDto {
  const QuestionDto._();

  const factory QuestionDto({
    required String id,
    required String testId,
    required String chapterId,
    required QuestionType type,
    required String questionText,
    List<String>? options,
    int? correctOptionIndex,
    String? expectedAnswer,
    String? solutionExplanation,
    @Default(1) int marks,
  }) = _QuestionDto;

  factory QuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionDtoFromJson(json);

  Question toDomain() => Question(
    id: id,
    testId: testId,
    chapterId: chapterId,
    type: type,
    questionText: questionText,
    options: options,
    correctOptionIndex: correctOptionIndex,
    expectedAnswer: expectedAnswer,
    solutionExplanation: solutionExplanation,
    marks: marks,
  );

  factory QuestionDto.fromDomain(Question entity) => QuestionDto(
    id: entity.id,
    testId: entity.testId,
    chapterId: entity.chapterId,
    type: entity.type,
    questionText: entity.questionText,
    options: entity.options,
    correctOptionIndex: entity.correctOptionIndex,
    expectedAnswer: entity.expectedAnswer,
    solutionExplanation: entity.solutionExplanation,
    marks: entity.marks,
  );
}
