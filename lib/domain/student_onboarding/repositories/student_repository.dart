import '../../common/result.dart';
import '../entities/student.dart';

/// Zero Flutter/Riverpod/package dependencies per §2 Clean Architecture
/// rules.
abstract class StudentRepository {
  /// Persists the final campus + board/class + subject-enrollment
  /// selections made across the 3-step onboarding flow.
  Future<Result<Student>> completeOnboarding(Student student);

  /// All students who have at least one subject-enrollment join row with
  /// `teacherId == teacherId` (project_spec.md §9.2 `SubjectEnrollment`),
  /// used by `teacher-students` (Students tab list + per-student progress
  /// detail).
  Future<Result<List<Student>>> getStudentsForTeacher(String teacherId);

  /// Persists a profile edit (name/phone) from the `student-profile`
  /// feature (§10.2 Profile "Edit profile"). Campus/board-class/subject
  /// selections are read-only here — editing those belongs to the
  /// onboarding flow, not profile.
  Future<Result<Student>> updateStudent(Student student);

  /// Soft-deletes the student's account (`Student.isDeleted = true`),
  /// mirroring `§10.2` Profile "delete account". Never hard-deletes.
  Future<Result<void>> deleteAccount(String studentId);
}
