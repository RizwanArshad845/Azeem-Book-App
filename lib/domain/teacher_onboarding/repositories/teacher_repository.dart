import '../../common/result.dart';
import '../entities/teacher.dart';

/// Zero Flutter/Riverpod/package dependencies per §2 Clean Architecture
/// rules. Concrete implementation calls the remote datasource directly —
/// never called directly from a viewmodel.
abstract class TeacherRepository {
  /// Looks up an existing Teacher by phone number, or `null` if none exists
  /// yet. Used to distinguish a salesman-seeded record (skip signup) from a
  /// brand new phone number (show the self-signup form).
  Future<Result<Teacher?>> getTeacherByPhone(String phoneNumber);

  /// Creates a new self-signup Teacher record (`pendingAdminApproval`).
  Future<Result<Teacher>> signUp(Teacher teacher);

  /// Persists a profile edit (name/phone) from the `teacher-profile`
  /// feature (§10.2 Profile "Edit profile"). Campus/subjects/classes/
  /// approval-status/earnings fields are read-only here — editing those
  /// belongs to onboarding/admin flows, not profile.
  Future<Result<Teacher>> updateTeacher(Teacher teacher);

  /// Soft-deletes the teacher's account (`Teacher.isDeleted = true`),
  /// mirroring §10.2 Profile "delete account" (applied here for parity with
  /// `student-profile` per §9.1's narrative text — see §10.2/§9.1
  /// scope-TBD note). Never hard-deletes.
  Future<Result<void>> deleteAccount(String teacherId);
}
