// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmissionAnswerDto _$SubmissionAnswerDtoFromJson(Map<String, dynamic> json) =>
    _SubmissionAnswerDto(
      questionId: json['questionId'] as String,
      type: $enumDecodeNullable(_$QuestionTypeEnumMap, json['type']),
      questionText: json['questionText'] as String?,
      answerText: json['answerText'] as String?,
      selectedOptionIndex: (json['selectedOptionIndex'] as num?)?.toInt(),
      expectedAnswer: json['expectedAnswer'] as String?,
      marksAwarded: (json['marksAwarded'] as num?)?.toInt(),
      possibleMarks: (json['possibleMarks'] as num?)?.toInt(),
      tokenJudgements: (json['tokenJudgements'] as List<dynamic>?)
          ?.map((e) => TokenJudgementDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      justification: json['justification'] as String?,
      solutionExplanation: json['solutionExplanation'] as String?,
      gradedByAi: json['gradedByAi'] as bool? ?? false,
    );

Map<String, dynamic> _$SubmissionAnswerDtoToJson(
  _SubmissionAnswerDto instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'type': _$QuestionTypeEnumMap[instance.type],
  'questionText': instance.questionText,
  'answerText': instance.answerText,
  'selectedOptionIndex': instance.selectedOptionIndex,
  'expectedAnswer': instance.expectedAnswer,
  'marksAwarded': instance.marksAwarded,
  'possibleMarks': instance.possibleMarks,
  'tokenJudgements': instance.tokenJudgements,
  'justification': instance.justification,
  'solutionExplanation': instance.solutionExplanation,
  'gradedByAi': instance.gradedByAi,
};

const _$QuestionTypeEnumMap = {
  QuestionType.mcq: 'mcq',
  QuestionType.shortAnswer: 'shortAnswer',
  QuestionType.longAnswer: 'longAnswer',
};
