import '../../../core/config/app_config.dart';
import '../../../domain/common/result.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/repositories/test_attempt_repository.dart';
import '../datasources/local/test_attempt_dummy_datasource.dart';
import '../datasources/remote/test_attempt_remote_datasource.dart';
import '../models/test_attempt_dto.dart';

/// Switches between [TestAttemptRemoteDataSource] and
/// [TestAttemptDummyDataSource] based on `AppConfig.isMockMode`
/// (project_spec.md §6.2) and maps DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
class TestAttemptRepositoryImpl implements TestAttemptRepository {
  TestAttemptRepositoryImpl({
    required this.remote,
    required this.dummy,
    this.isMockMode = AppConfig.isMockMode,
  });

  final TestAttemptRemoteDataSource remote;
  final TestAttemptDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<TestAttempt>> submitAttempt(TestAttempt attempt) async {
    final dto = TestAttemptDto.fromDomain(attempt);
    final result = isMockMode
        ? await dummy.submitAttempt(dto)
        : await remote.submitAttempt(dto);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<TestAttempt>>> getAttemptsForStudent(
    String studentId,
  ) async {
    final result = isMockMode
        ? await dummy.getAttemptsForStudent(studentId)
        : await remote.getAttemptsForStudent(studentId);
    return result.when(
      success: (dtos) => Success(dtos.map((dto) => dto.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
