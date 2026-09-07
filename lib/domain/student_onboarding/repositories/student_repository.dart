import '../../common/result.dart';
import '../entities/student.dart';
import '../entities/subject_enrollment.dart';

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

  /// Looks up the current student's own profile by id — the student
  /// equivalent of `TeacherRepository.getTeacherByPhone`. Returns `null` if
  /// no `Student` row exists yet (onboarding not completed), letting
  /// `StudentOnboardingViewModel.build()` re-derive the current student
  /// whenever the logged-in session changes instead of the previous user's
  /// cached profile surviving a logout/relogin.
  Future<Result<Student?>> getStudentById(String studentId);

  /// Updates the student's subject enrollments and assigned teachers.
  Future<Result<List<SubjectEnrollment>>> updateSubjectEnrollments(
    String studentId,
    List<SubjectEnrollment> enrollments,
  );

  /// Reads the current student's subject enrollments from backend.
  Future<Result<List<SubjectEnrollment>>> getSubjectEnrollments(
    String studentId,
  );
}
