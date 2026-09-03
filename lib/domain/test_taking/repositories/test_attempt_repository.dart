import '../../common/result.dart';
import '../entities/test_attempt.dart';
import '../entities/test_attempt_session.dart';

/// Persists and grades a student's [TestAttempt] (project_spec.md §9.2
/// `TestAttempt`). Concrete implementation calls the remote datasource
/// directly — never called directly from a viewmodel.
abstract class TestAttemptRepository {
  /// Starts a new attempt at [testId], returning the questions (answer-key
  /// free) and the server-authoritative deadline for the countdown timer.
  Future<Result<TestAttemptSession>> startAttempt(String testId);

  /// Submits the complete, locally-collected (raw, ungraded) answer set for
  /// [attemptId] and kicks off server-side grading — does not return the
  /// graded result inline; poll [getAttempt] until `status == graded`.
  Future<Result<void>> submitAttempt(
    String attemptId,
    Map<String, Object> rawAnswers,
  );

  /// Fetches the current state of [attemptId] — used both to poll a
  /// just-submitted attempt until it's graded, and to fetch an
  /// already-graded attempt's full detail.
  Future<Result<TestAttempt>> getAttempt(String attemptId);

  /// All attempts previously submitted by [studentId], used by
  /// `student-progress` (attempted-tests list, weak/strong chapter
  /// aggregation) and eventually `teacher-students` (per-student detail).
  Future<Result<List<TestAttempt>>> getAttemptsForStudent(String studentId);
}
