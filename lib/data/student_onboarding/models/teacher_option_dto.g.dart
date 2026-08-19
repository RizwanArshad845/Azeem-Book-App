// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_option_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherOptionDto _$TeacherOptionDtoFromJson(Map<String, dynamic> json) =>
    _TeacherOptionDto(
      id: json['id'] as String,
      name: json['name'] as String,
      campusId: json['campusId'] as String,
      subjectIds: (json['subjectIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TeacherOptionDtoToJson(_TeacherOptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'campusId': instance.campusId,
      'subjectIds': instance.subjectIds,
    };
