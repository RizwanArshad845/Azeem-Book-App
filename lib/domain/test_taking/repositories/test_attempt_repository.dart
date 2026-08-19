import '../../common/result.dart';
import '../entities/test_attempt.dart';

/// Persists a student's graded [TestAttempt] (project_spec.md §9.2
/// `TestAttempt`). Concrete implementation picks a dummy or remote
/// datasource based on `AppConfig.isMockMode` (§6.2) — never called
/// directly from a viewmodel.
abstract class TestAttemptRepository {
  /// Grades and persists [attempt] (already fully graded by the domain
  /// use cases before this is called), returning the stored record.
  Future<Result<TestAttempt>> submitAttempt(TestAttempt attempt);

  /// All attempts previously submitted by [studentId], used by
  /// `student-progress` (attempted-tests list, weak/strong chapter
  /// aggregation) and eventually `teacher-students` (per-student detail).
  Future<Result<List<TestAttempt>>> getAttemptsForStudent(String studentId);
}
