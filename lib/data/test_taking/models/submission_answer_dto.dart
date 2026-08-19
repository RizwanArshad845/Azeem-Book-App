import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/test_taking/entities/submission_answer.dart';

part 'submission_answer_dto.freezed.dart';
part 'submission_answer_dto.g.dart';

@freezed
abstract class SubmissionAnswerDto with _$SubmissionAnswerDto {
  const SubmissionAnswerDto._();

  const factory SubmissionAnswerDto({
    required String questionId,
    String? answerText,
    int? selectedOptionIndex,
    bool? isCorrect,
    @Default(false) bool gradedByAi,
  }) = _SubmissionAnswerDto;

  factory SubmissionAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$SubmissionAnswerDtoFromJson(json);

  SubmissionAnswer toDomain() => SubmissionAnswer(
    questionId: questionId,
    answerText: answerText,
    selectedOptionIndex: selectedOptionIndex,
    isCorrect: isCorrect,
    gradedByAi: gradedByAi,
  );

  factory SubmissionAnswerDto.fromDomain(SubmissionAnswer entity) =>
      SubmissionAnswerDto(
        questionId: entity.questionId,
        answerText: entity.answerText,
        selectedOptionIndex: entity.selectedOptionIndex,
        isCorrect: entity.isCorrect,
        gradedByAi: entity.gradedByAi,
      );
}
