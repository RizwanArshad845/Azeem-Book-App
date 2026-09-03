import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';
import 'token_judgement_dto.dart';

part 'submission_answer_dto.freezed.dart';
part 'submission_answer_dto.g.dart';

@freezed
abstract class SubmissionAnswerDto with _$SubmissionAnswerDto {
  const SubmissionAnswerDto._();

  const factory SubmissionAnswerDto({
    required String questionId,
    QuestionType? type,
    String? questionText,
    String? answerText,
    int? selectedOptionIndex,
    String? expectedAnswer,
    int? marksAwarded,
    int? possibleMarks,
    List<TokenJudgementDto>? tokenJudgements,
    String? justification,
    String? solutionExplanation,
    @Default(false) bool gradedByAi,
  }) = _SubmissionAnswerDto;

  factory SubmissionAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$SubmissionAnswerDtoFromJson(json);

  SubmissionAnswer toDomain() => SubmissionAnswer(
    questionId: questionId,
    type: type,
    questionText: questionText,
    answerText: answerText,
    selectedOptionIndex: selectedOptionIndex,
    expectedAnswer: expectedAnswer,
    marksAwarded: marksAwarded,
    possibleMarks: possibleMarks,
    tokenJudgements: tokenJudgements?.map((t) => t.toDomain()).toList(),
    justification: justification,
    solutionExplanation: solutionExplanation,
    gradedByAi: gradedByAi,
  );

  factory SubmissionAnswerDto.fromDomain(SubmissionAnswer entity) =>
      SubmissionAnswerDto(
        questionId: entity.questionId,
        type: entity.type,
        questionText: entity.questionText,
        answerText: entity.answerText,
        selectedOptionIndex: entity.selectedOptionIndex,
        expectedAnswer: entity.expectedAnswer,
        marksAwarded: entity.marksAwarded,
        possibleMarks: entity.possibleMarks,
        tokenJudgements: entity.tokenJudgements
            ?.map(TokenJudgementDto.fromDomain)
            .toList(),
        justification: entity.justification,
        solutionExplanation: entity.solutionExplanation,
        gradedByAi: entity.gradedByAi,
      );
}
