import '../../common/result.dart';
import '../entities/test_attempt_session.dart';
import '../repositories/test_attempt_repository.dart';

/// Single-purpose use case: start a new attempt at [testId].
class StartTestAttemptUseCase {
  const StartTestAttemptUseCase(this._repository);

  final TestAttemptRepository _repository;

  Future<Result<TestAttemptSession>> call(String testId) =>
      _repository.startAttempt(testId);
}
