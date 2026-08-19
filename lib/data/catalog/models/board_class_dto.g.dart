// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_class_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoardClassDto _$BoardClassDtoFromJson(Map<String, dynamic> json) =>
    _BoardClassDto(
      id: json['id'] as String,
      name: json['name'] as String,
      isEnabled: json['isEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$BoardClassDtoToJson(_BoardClassDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isEnabled': instance.isEnabled,
    };
