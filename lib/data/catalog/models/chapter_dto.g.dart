// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterDto _$ChapterDtoFromJson(Map<String, dynamic> json) => _ChapterDto(
  id: json['id'] as String,
  subjectId: json['subjectId'] as String,
  title: json['title'] as String,
  order: (json['order'] as num).toInt(),
);

Map<String, dynamic> _$ChapterDtoToJson(_ChapterDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subjectId': instance.subjectId,
      'title': instance.title,
      'order': instance.order,
    };
