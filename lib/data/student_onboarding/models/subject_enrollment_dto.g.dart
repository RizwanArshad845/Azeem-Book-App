// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_enrollment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubjectEnrollmentDto _$SubjectEnrollmentDtoFromJson(
  Map<String, dynamic> json,
) => _SubjectEnrollmentDto(
  studentId: json['studentId'] as String,
  subjectId: json['subjectId'] as String,
  teacherId: json['teacherId'] as String?,
  discountApplied: json['discountApplied'] as bool? ?? false,
);

Map<String, dynamic> _$SubjectEnrollmentDtoToJson(
  _SubjectEnrollmentDto instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'subjectId': instance.subjectId,
  'teacherId': instance.teacherId,
  'discountApplied': instance.discountApplied,
};
