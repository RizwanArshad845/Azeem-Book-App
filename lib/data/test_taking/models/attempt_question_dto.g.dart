// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attempt_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttemptQuestionDto _$AttemptQuestionDtoFromJson(Map<String, dynamic> json) =>
    _AttemptQuestionDto(
      id: json['id'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      marks: (json['marks'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$AttemptQuestionDtoToJson(_AttemptQuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'questionText': instance.questionText,
      'options': instance.options,
      'marks': instance.marks,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.mcq: 'mcq',
  QuestionType.shortAnswer: 'shortAnswer',
  QuestionType.longAnswer: 'longAnswer',
};
