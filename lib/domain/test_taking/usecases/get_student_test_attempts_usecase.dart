import '../../common/result.dart';
import '../entities/test_attempt.dart';
import '../repositories/test_attempt_repository.dart';

/// Fetches every [TestAttempt] a student has submitted, newest first
/// (project_spec.md §9.2 `TestAttempt`). Consumed by `student-progress`
/// (attempted-tests list + weak/strong chapter aggregation) and eventually
/// `teacher-students`' per-student detail view.
class GetStudentTestAttemptsUseCase {
  const GetStudentTestAttemptsUseCase(this._repository);

  final TestAttemptRepository _repository;

  Future<Result<List<TestAttempt>>> call(String studentId) =>
      _repository.getAttemptsForStudent(studentId);
}
