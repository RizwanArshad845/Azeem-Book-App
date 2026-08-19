import '../../../../domain/common/result.dart';
import '../../models/test_attempt_dto.dart';

/// Same method signature as [TestAttemptRemoteDataSource] so the repository
/// can swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class TestAttemptDummyDataSource {
  Future<Result<TestAttemptDto>> submitAttempt(TestAttemptDto attempt);

  Future<Result<List<TestAttemptDto>>> getAttemptsForStudent(
    String studentId,
  );
}

/// In-memory list of submitted attempts (this session only — no persistence
/// across app restarts needed for Phase 1). Always resolves `success` after
/// a short simulated latency.
class TestAttemptDummyDataSourceImpl implements TestAttemptDummyDataSource {
  static const _latency = Duration(milliseconds: 500);

  final List<TestAttemptDto> _attempts = [];

  @override
  Future<Result<TestAttemptDto>> submitAttempt(TestAttemptDto attempt) async {
    await Future.delayed(_latency);
    _attempts.add(attempt);
    return Success(attempt);
  }

  @override
  Future<Result<List<TestAttemptDto>>> getAttemptsForStudent(
    String studentId,
  ) async {
    await Future.delayed(_latency);
    final attempts = _attempts.where((a) => a.studentId == studentId).toList()
      ..sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));
    return Success(attempts);
  }
}
