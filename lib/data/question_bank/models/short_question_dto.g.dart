// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShortQuestionDto _$ShortQuestionDtoFromJson(Map<String, dynamic> json) =>
    _ShortQuestionDto(
      id: json['id'] as String,
      chapter: (json['chapter'] as num).toInt(),
      question: json['question'] as String,
      modelAnswer: json['modelAnswer'] as String,
    );

Map<String, dynamic> _$ShortQuestionDtoToJson(_ShortQuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapter': instance.chapter,
      'question': instance.question,
      'modelAnswer': instance.modelAnswer,
    };
