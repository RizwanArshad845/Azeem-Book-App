import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/entities/user_role.dart';
import 'subject_enrollment.dart';

part 'student.freezed.dart';

/// project_spec.md §9.2 declares `Student extends User`, but this codebase's
/// flat-freezed-class convention has no inheritance, so `User`'s base fields
/// (`id`, `name`, `phoneNumber`, `role`, `isDeleted`, `createdAt`,
/// `updatedAt`) are flattened directly here alongside Student's own fields
/// (`campusId`, `boardClassId`, `subjectEnrollments`, `cartId`).
@freezed
abstract class Student with _$Student {
  const factory Student({
    required String id,
    required String name,
    required String phoneNumber,
    // Reuses the existing UserRole enum (already scoped to {teacher,
    // student}, see lib/domain/auth/entities/user_role.dart) rather than
    // inventing a separate Student-specific role type.
    required UserRole role,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String campusId,
    // Must reference an Admin-enabled BoardClass (§9.2 note).
    String? boardClassId,
    List<SubjectEnrollment>? subjectEnrollments,
    // No cart feature exists yet — nullable FK carried for forward
    // compatibility per §9.2.
    String? cartId,
  }) = _Student;
}
