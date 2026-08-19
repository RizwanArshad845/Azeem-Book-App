import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';

part 'teacher_dto.freezed.dart';
part 'teacher_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of the eventual `/teachers`
/// endpoints. Identical field shape for both the dummy and remote
/// datasources so flipping `AppConfig.isMockMode` requires zero call-site
/// changes (§6.1). Flattens `User` base fields directly — see the `Teacher`
/// entity doc for why (§9.2 models inheritance this codebase's generated
/// freezed classes don't support). Reuses the domain-layer
/// `TeacherOnboardingSource`/`TeacherApprovalStatus` enums directly, same as
/// `QuestionDto` reusing `QuestionType` from `domain/catalog`.
@freezed
abstract class TeacherDto with _$TeacherDto {
  const TeacherDto._();

  const factory TeacherDto({
    required String id,
    required String name,
    required String phoneNumber,
    required UserRole role,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String campusId,
    required List<String> subjects,
    List<String>? classes,
    int? declaredStudentCount,
    String? salesmanId,
    required TeacherOnboardingSource onboardingSource,
    required TeacherApprovalStatus approvalStatus,
    @Default(0) double actualEarnings,
    double? projectedEarnings,
  }) = _TeacherDto;

  factory TeacherDto.fromJson(Map<String, dynamic> json) =>
      _$TeacherDtoFromJson(json);

  Teacher toDomain() => Teacher(
    id: id,
    name: name,
    phoneNumber: phoneNumber,
    role: role,
    isDeleted: isDeleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
    campusId: campusId,
    subjects: subjects,
    classes: classes,
    declaredStudentCount: declaredStudentCount,
    salesmanId: salesmanId,
    onboardingSource: onboardingSource,
    approvalStatus: approvalStatus,
    actualEarnings: actualEarnings,
    projectedEarnings: projectedEarnings,
  );

  factory TeacherDto.fromDomain(Teacher entity) => TeacherDto(
    id: entity.id,
    name: entity.name,
    phoneNumber: entity.phoneNumber,
    role: entity.role,
    isDeleted: entity.isDeleted,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    campusId: entity.campusId,
    subjects: entity.subjects,
    classes: entity.classes,
    declaredStudentCount: entity.declaredStudentCount,
    salesmanId: entity.salesmanId,
    onboardingSource: entity.onboardingSource,
    approvalStatus: entity.approvalStatus,
    actualEarnings: entity.actualEarnings,
    projectedEarnings: entity.projectedEarnings,
  );
}
