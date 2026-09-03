import '../../common/result.dart';
import '../entities/test_attempt.dart';
import '../repositories/test_attempt_repository.dart';

/// Single-purpose use case: fetch the current state of [attemptId] — used
/// both to poll a just-submitted attempt until it's graded, and to fetch an
/// already-graded attempt's full detail.
class GetAttemptUseCase {
  const GetAttemptUseCase(this._repository);

  final TestAttemptRepository _repository;

  Future<Result<TestAttempt>> call(String attemptId) =>
      _repository.getAttempt(attemptId);
}
