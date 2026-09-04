import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/student_onboarding/entities/subject_enrollment.dart';

part 'subject_enrollment_dto.freezed.dart';
part 'subject_enrollment_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of a `SubjectEnrollment` row per
/// §9.2.
@freezed
abstract class SubjectEnrollmentDto with _$SubjectEnrollmentDto {
  const SubjectEnrollmentDto._();

  const factory SubjectEnrollmentDto({
    // Nullable: `FRONTEND_INTEGRATION.md` §6.3's response shape is `{id,
    // subjectId, teacherId, discountApplied}` — no `studentId`.
    String? studentId,
    String? id,
    required String subjectId,
    String? teacherId,
    @Default(false) bool discountApplied,
  }) = _SubjectEnrollmentDto;

  factory SubjectEnrollmentDto.fromJson(Map<String, dynamic> json) =>
      _$SubjectEnrollmentDtoFromJson(json);

  SubjectEnrollment toDomain() => SubjectEnrollment(
    studentId: studentId,
    id: id,
    subjectId: subjectId,
    teacherId: teacherId,
    discountApplied: discountApplied,
  );

  factory SubjectEnrollmentDto.fromDomain(SubjectEnrollment entity) =>
      SubjectEnrollmentDto(
        studentId: entity.studentId,
        id: entity.id,
        subjectId: entity.subjectId,
        teacherId: entity.teacherId,
        discountApplied: entity.discountApplied,
      );
}
