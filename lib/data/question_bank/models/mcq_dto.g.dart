// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_McqDto _$McqDtoFromJson(Map<String, dynamic> json) => _McqDto(
  id: json['id'] as String,
  chapter: (json['chapter'] as num).toInt(),
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIndex: (json['correctIndex'] as num).toInt(),
);

Map<String, dynamic> _$McqDtoToJson(_McqDto instance) => <String, dynamic>{
  'id': instance.id,
  'chapter': instance.chapter,
  'question': instance.question,
  'options': instance.options,
  'correctIndex': instance.correctIndex,
};
