// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherDto _$TeacherDtoFromJson(Map<String, dynamic> json) => _TeacherDto(
  id: json['id'] as String,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  isDeleted: json['isDeleted'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  campusId: json['campusId'] as String,
  subjects: (json['subjects'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  classes: (json['classes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  declaredStudentCount: (json['declaredStudentCount'] as num?)?.toInt(),
  salesmanId: json['salesmanId'] as String?,
  onboardingSource: $enumDecode(
    _$TeacherOnboardingSourceEnumMap,
    json['onboardingSource'],
  ),
  approvalStatus: $enumDecode(
    _$TeacherApprovalStatusEnumMap,
    json['approvalStatus'],
  ),
  actualEarnings: (json['actualEarnings'] as num?)?.toDouble() ?? 0,
  projectedEarnings: (json['projectedEarnings'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TeacherDtoToJson(
  _TeacherDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'role': _$UserRoleEnumMap[instance.role]!,
  'isDeleted': instance.isDeleted,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'campusId': instance.campusId,
  'subjects': instance.subjects,
  'classes': instance.classes,
  'declaredStudentCount': instance.declaredStudentCount,
  'salesmanId': instance.salesmanId,
  'onboardingSource':
      _$TeacherOnboardingSourceEnumMap[instance.onboardingSource]!,
  'approvalStatus': _$TeacherApprovalStatusEnumMap[instance.approvalStatus]!,
  'actualEarnings': instance.actualEarnings,
  'projectedEarnings': instance.projectedEarnings,
};

const _$UserRoleEnumMap = {
  UserRole.teacher: 'teacher',
  UserRole.student: 'student',
};

const _$TeacherOnboardingSourceEnumMap = {
  TeacherOnboardingSource.salesmanSeeded: 'salesmanSeeded',
  TeacherOnboardingSource.selfSignup: 'selfSignup',
};

const _$TeacherApprovalStatusEnumMap = {
  TeacherApprovalStatus.approved: 'approved',
  TeacherApprovalStatus.pendingAdminApproval: 'pendingAdminApproval',
};
