import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import 'subject_enrollment_dto.dart';

part 'student_dto.freezed.dart';
part 'student_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of `/students/{id}` per §9.2.
/// Flattened the same way as the [Student] domain entity (see that file's
/// doc comment re: the `Student extends User` schema footgun).
@freezed
abstract class StudentDto with _$StudentDto {
  const StudentDto._();

  const factory StudentDto({
    required String id,
    required String name,
    required String phoneNumber,
    required UserRole role,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String campusId,
    String? boardClassId,
    List<SubjectEnrollmentDto>? subjectEnrollments,
    String? cartId,
  }) = _StudentDto;

  factory StudentDto.fromJson(Map<String, dynamic> json) =>
      _$StudentDtoFromJson(json);

  Student toDomain() => Student(
    id: id,
    name: name,
    phoneNumber: phoneNumber,
    role: role,
    isDeleted: isDeleted,
    createdAt: createdAt,
    updatedAt: updatedAt,
    campusId: campusId,
    boardClassId: boardClassId,
    subjectEnrollments: subjectEnrollments?.map((e) => e.toDomain()).toList(),
    cartId: cartId,
  );

  factory StudentDto.fromDomain(Student entity) => StudentDto(
    id: entity.id,
    name: entity.name,
    phoneNumber: entity.phoneNumber,
    role: entity.role,
    isDeleted: entity.isDeleted,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    campusId: entity.campusId,
    boardClassId: entity.boardClassId,
    subjectEnrollments: entity.subjectEnrollments
        ?.map((e) => SubjectEnrollmentDto.fromDomain(e))
        .toList(),
    cartId: entity.cartId,
  );
}
