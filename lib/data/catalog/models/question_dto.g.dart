// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionDto _$QuestionDtoFromJson(Map<String, dynamic> json) => _QuestionDto(
  id: json['id'] as String,
  testId: json['testId'] as String,
  chapterId: json['chapterId'] as String,
  type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
  questionText: json['questionText'] as String,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  correctOptionIndex: (json['correctOptionIndex'] as num?)?.toInt(),
  expectedAnswer: json['expectedAnswer'] as String?,
  solutionExplanation: json['solutionExplanation'] as String?,
  marks: (json['marks'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$QuestionDtoToJson(_QuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testId': instance.testId,
      'chapterId': instance.chapterId,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'questionText': instance.questionText,
      'options': instance.options,
      'correctOptionIndex': instance.correctOptionIndex,
      'expectedAnswer': instance.expectedAnswer,
      'solutionExplanation': instance.solutionExplanation,
      'marks': instance.marks,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.mcq: 'mcq',
  QuestionType.shortAnswer: 'shortAnswer',
  QuestionType.longAnswer: 'longAnswer',
};
