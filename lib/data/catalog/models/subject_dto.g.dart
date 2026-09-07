// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubjectDto _$SubjectDtoFromJson(Map<String, dynamic> json) => _SubjectDto(
  id: json['id'] as String,
  name: json['name'] as String,
  boardClassId: json['boardClassId'] as String,
  bundlePrice: (json['bundlePrice'] as num).toInt(),
);

Map<String, dynamic> _$SubjectDtoToJson(_SubjectDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'boardClassId': instance.boardClassId,
      'bundlePrice': instance.bundlePrice,
    };
