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

/// In-memory list of submitted attempts seeded with initial test history.
class TestAttemptDummyDataSourceImpl implements TestAttemptDummyDataSource {
  TestAttemptDummyDataSourceImpl() {
    _initMockAttempts();
  }

  static const _latency = Duration(milliseconds: 500);

  final List<TestAttemptDto> _attempts = [];

  void _initMockAttempts() {
    final now = DateTime.now();
    _attempts.addAll([
      TestAttemptDto(
        id: 'attempt-001',
        studentId: 'student-001',
        testId: 'test-physics-ch1',
        answers: const [],
        scorePercent: 88.0,
        durationSeconds: 1200,
        attemptedAt: now.subtract(const Duration(days: 2)),
      ),
      TestAttemptDto(
        id: 'attempt-002',
        studentId: 'student-001',
        testId: 'test-physics-ch2',
        answers: const [],
        scorePercent: 92.0,
        durationSeconds: 1100,
        attemptedAt: now.subtract(const Duration(days: 5)),
      ),
      TestAttemptDto(
        id: 'attempt-003',
        studentId: 'student-002',
        testId: 'test-math-ch1',
        answers: const [],
        scorePercent: 95.0,
        durationSeconds: 1500,
        attemptedAt: now.subtract(const Duration(days: 1)),
      ),
      TestAttemptDto(
        id: 'attempt-004',
        studentId: 'student-003',
        testId: 'test-chem-ch1',
        answers: const [],
        scorePercent: 78.0,
        durationSeconds: 1350,
        attemptedAt: now.subtract(const Duration(days: 3)),
      ),
      TestAttemptDto(
        id: 'attempt-005',
        studentId: 'student-004',
        testId: 'test-physics-ch1',
        answers: const [],
        scorePercent: 85.0,
        durationSeconds: 1250,
        attemptedAt: now.subtract(const Duration(days: 4)),
      ),
      TestAttemptDto(
        id: 'attempt-006',
        studentId: 'student-005',
        testId: 'test-bio-ch1',
        answers: const [],
        scorePercent: 90.0,
        durationSeconds: 1100,
        attemptedAt: now.subtract(const Duration(days: 2)),
      ),
      TestAttemptDto(
        id: 'attempt-007',
        studentId: 'student-006',
        testId: 'test-math-ch1',
        answers: const [],
        scorePercent: 74.0,
        durationSeconds: 1400,
        attemptedAt: now.subtract(const Duration(days: 6)),
      ),
      TestAttemptDto(
        id: 'attempt-008',
        studentId: 'student-007',
        testId: 'test-chem-ch1',
        answers: const [],
        scorePercent: 82.0,
        durationSeconds: 1300,
        attemptedAt: now.subtract(const Duration(days: 1)),
      ),
      TestAttemptDto(
        id: 'attempt-009',
        studentId: 'student-008',
        testId: 'test-math-ch1',
        answers: const [],
        scorePercent: 89.0,
        durationSeconds: 1200,
        attemptedAt: now.subtract(const Duration(days: 3)),
      ),
      TestAttemptDto(
        id: 'attempt-010',
        studentId: 'student-009',
        testId: 'test-physics-ch1',
        answers: const [],
        scorePercent: 94.0,
        durationSeconds: 1050,
        attemptedAt: now.subtract(const Duration(days: 2)),
      ),
      TestAttemptDto(
        id: 'attempt-011',
        studentId: 'student-010',
        testId: 'test-bio-ch1',
        answers: const [],
        scorePercent: 86.0,
        durationSeconds: 1150,
        attemptedAt: now.subtract(const Duration(days: 4)),
      ),
      TestAttemptDto(
        id: 'attempt-012',
        studentId: 'student-011',
        testId: 'test-math-ch1',
        answers: const [],
        scorePercent: 70.0,
        durationSeconds: 1300,
        attemptedAt: now.subtract(const Duration(days: 5)),
      ),
      TestAttemptDto(
        id: 'attempt-013',
        studentId: 'student-012',
        testId: 'test-physics-ch1',
        answers: const [],
        scorePercent: 65.0,
        durationSeconds: 900,
        attemptedAt: now.subtract(const Duration(days: 7)),
      ),
      TestAttemptDto(
        id: 'attempt-014',
        studentId: 'student-014',
        testId: 'test-physics-ch1',
        answers: const [],
        scorePercent: 60.0,
        durationSeconds: 850,
        attemptedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

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
