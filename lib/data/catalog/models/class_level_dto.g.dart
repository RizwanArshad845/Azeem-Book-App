// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_level_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClassLevelDto _$ClassLevelDtoFromJson(Map<String, dynamic> json) =>
    _ClassLevelDto(
      id: json['id'] as String,
      name: json['name'] as String,
      isEnabled: json['isEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$ClassLevelDtoToJson(_ClassLevelDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isEnabled': instance.isEnabled,
    };
