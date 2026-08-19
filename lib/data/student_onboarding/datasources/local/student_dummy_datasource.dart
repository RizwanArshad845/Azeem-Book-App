import '../../models/student_dto.dart';
import '../../models/subject_enrollment_dto.dart';

/// Same method signature as [StudentRemoteDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class StudentDummyDataSource {
  Future<StudentDto> completeOnboarding(StudentDto student);

  /// All students, filtered to those with a `subjectEnrollments` entry whose
  /// `teacherId` matches. Session-scoped like `TestAttemptDummyDataSourceImpl`
  /// (`lib/data/test_taking/datasources/local/test_attempt_dummy_datasource.dart`)
  /// — only students that completed onboarding earlier in this app session
  /// are visible, since this datasource has no persistence across restarts.
  Future<List<StudentDto>> getStudentsForTeacher(String teacherId);

  /// Persists a name/phone edit from `student-profile`. Campus/board-class/
  /// subject-enrollment fields are left untouched.
  Future<StudentDto> updateStudent(StudentDto student);

  /// Soft-deletes (`isDeleted = true`) the in-memory record, if any.
  Future<void> deleteAccount(String studentId);
}

/// In-memory "backend" for onboarding completion — echoes the submitted
/// student back after simulated latency, stamping `updatedAt` the way a
/// real API would on a successful write.
class StudentDummyDataSourceImpl implements StudentDummyDataSource {
  final Map<String, StudentDto> _students = {};

  @override
  Future<StudentDto> completeOnboarding(StudentDto student) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final saved = student.copyWith(updatedAt: DateTime.now());
    _students[saved.id] = saved;
    return saved;
  }

  @override
  Future<List<StudentDto>> getStudentsForTeacher(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _students.values
        .where(
          (s) => (s.subjectEnrollments ?? const <SubjectEnrollmentDto>[]).any(
            (e) => e.teacherId == teacherId,
          ),
        )
        .toList();
  }

  /// Merges the name/phone edit onto whatever's already recorded for this
  /// student (falls back to the incoming DTO as-is if onboarding never ran
  /// in this session), stamping `updatedAt` like [completeOnboarding] does.
  @override
  Future<StudentDto> updateStudent(StudentDto student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _students[student.id] ?? student;
    final saved = existing.copyWith(
      name: student.name,
      phoneNumber: student.phoneNumber,
      updatedAt: DateTime.now(),
    );
    _students[saved.id] = saved;
    return saved;
  }

  @override
  Future<void> deleteAccount(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final existing = _students[studentId];
    if (existing != null) {
      _students[studentId] = existing.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );
    }
  }
}
