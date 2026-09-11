// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebook_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EbookDto _$EbookDtoFromJson(Map<String, dynamic> json) => _EbookDto(
  subjectId: json['subjectId'] as String,
  status: json['status'] as String,
  pageCount: (json['pageCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$EbookDtoToJson(_EbookDto instance) => <String, dynamic>{
  'subjectId': instance.subjectId,
  'status': instance.status,
  'pageCount': instance.pageCount,
};
