import '../../../domain/common/result.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/entities/test_attempt_session.dart';
import '../../../domain/test_taking/repositories/test_attempt_repository.dart';
import '../datasources/remote/test_attempt_remote_datasource.dart';

/// Maps [TestAttemptRemoteDataSource] DTOs to domain entities so nothing
/// above this layer ever sees a DTO.
class TestAttemptRepositoryImpl implements TestAttemptRepository {
  TestAttemptRepositoryImpl({required this.remote});

  final TestAttemptRemoteDataSource remote;

  @override
  Future<Result<TestAttemptSession>> startAttempt(String testId) async {
    final result = await remote.startAttempt(testId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<void>> submitAttempt(
    String attemptId,
    Map<String, Object> rawAnswers,
  ) {
    return remote.submitAttempt(attemptId, rawAnswers);
  }

  @override
  Future<Result<TestAttempt>> getAttempt(String attemptId) async {
    final result = await remote.getAttempt(attemptId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<TestAttempt>>> getAttemptsForStudent(
    String studentId,
  ) async {
    final result = await remote.getAttemptsForStudent(studentId);
    return result.when(
      success: (dtos) => Success(dtos.map((dto) => dto.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
