import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/entities/user_role.dart';

part 'teacher.freezed.dart';

/// How this Teacher record came to exist (project_spec.md §9.1/§9.2). A
/// Teacher is either pre-seeded via the Salesman/Azeem-Books database (OTP
/// login only, skips signup) or self-signs-up and awaits Admin approval.
enum TeacherOnboardingSource { salesmanSeeded, selfSignup }

/// Approval gate for self-signed-up Teachers. Salesman-seeded Teachers are
/// always [approved] outright; self-signup Teachers start
/// [pendingAdminApproval] and function identically to an approved teacher
/// once approved (project_spec.md §9.1/§9.2).
enum TeacherApprovalStatus { approved, pendingAdminApproval }

/// Teacher entity per project_spec.md §9.2. The spec models
/// `Teacher extends User`, but this codebase's freezed entity generation
/// produces flat classes with no inheritance, so `User`'s base fields
/// (`id, name, phoneNumber, role, isDeleted, createdAt, updatedAt`) are
/// flattened directly onto this entity alongside Teacher's own fields.
@freezed
abstract class Teacher with _$Teacher {
  const factory Teacher({
    // --- User base fields (flattened; see class doc) ---
    required String id,
    required String name,
    required String phoneNumber,
    // Reuses the existing `UserRole` enum from domain/auth (already scoped
    // to exactly {teacher, student}) instead of inventing a new one — a
    // Teacher's `role` is always `UserRole.teacher`.
    required UserRole role,
    @Default(false) bool isDeleted,
    required DateTime createdAt,
    required DateTime updatedAt,

    // --- Teacher-specific fields (§9.2) ---
    required String campusId,
    // Wire key is `subjectIds`/`classIds` (uuid references, not names) per
    // `FRONTEND_INTEGRATION.md` §6.2 — resolve display names via the
    // catalog subjects/board-classes lists, don't render these raw.
    required List<String> subjectIds,
    List<String>? classIds,
    int? declaredStudentCount,
    String? salesmanId,
    required TeacherOnboardingSource onboardingSource,
    required TeacherApprovalStatus approvalStatus,
    @Default(0) double actualEarnings,
    double? projectedEarnings,
  }) = _Teacher;
}
