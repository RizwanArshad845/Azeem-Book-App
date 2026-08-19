// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentDto _$StudentDtoFromJson(Map<String, dynamic> json) => _StudentDto(
  id: json['id'] as String,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  isDeleted: json['isDeleted'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  campusId: json['campusId'] as String,
  boardClassId: json['boardClassId'] as String?,
  subjectEnrollments: (json['subjectEnrollments'] as List<dynamic>?)
      ?.map((e) => SubjectEnrollmentDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  cartId: json['cartId'] as String?,
);

Map<String, dynamic> _$StudentDtoToJson(_StudentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'campusId': instance.campusId,
      'boardClassId': instance.boardClassId,
      'subjectEnrollments': instance.subjectEnrollments,
      'cartId': instance.cartId,
    };

const _$UserRoleEnumMap = {
  UserRole.teacher: 'teacher',
  UserRole.student: 'student',
};
