// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterDto _$ChapterDtoFromJson(Map<String, dynamic> json) => _ChapterDto(
  chapter: (json['chapter'] as num).toInt(),
  title: json['title'] as String,
  mcqCount: (json['mcqCount'] as num).toInt(),
  shortCount: (json['shortCount'] as num).toInt(),
);

Map<String, dynamic> _$ChapterDtoToJson(_ChapterDto instance) =>
    <String, dynamic>{
      'chapter': instance.chapter,
      'title': instance.title,
      'mcqCount': instance.mcqCount,
      'shortCount': instance.shortCount,
    };
