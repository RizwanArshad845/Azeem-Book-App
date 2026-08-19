import '../../../core/config/app_config.dart';
import '../../../domain/common/result.dart';
import '../../../domain/live_test_registration/entities/live_test_registration.dart';
import '../../../domain/live_test_registration/repositories/live_test_registration_repository.dart';
import '../datasources/local/live_test_registration_dummy_datasource.dart';
import '../datasources/remote/live_test_registration_remote_datasource.dart';

/// Switches between [LiveTestRegistrationRemoteDataSource] and
/// [LiveTestRegistrationDummyDataSource] based on `AppConfig.isMockMode`
/// (project_spec.md §6.2) and maps DTOs to domain entities so nothing above
/// this layer ever sees a DTO — mirrors `CartRepositoryImpl`.
class LiveTestRegistrationRepositoryImpl
    implements LiveTestRegistrationRepository {
  LiveTestRegistrationRepositoryImpl({
    required this.remote,
    required this.dummy,
    this.isMockMode = AppConfig.isMockMode,
  });

  final LiveTestRegistrationRemoteDataSource remote;
  final LiveTestRegistrationDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<LiveTestRegistration>> registerForLiveTest({
    required String studentId,
    required String testId,
  }) async {
    final result = isMockMode
        ? await dummy.register(studentId, testId)
        : await remote.register(studentId, testId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<LiveTestRegistration>>> getRegistrationsForStudent(
    String studentId,
  ) async {
    final result = isMockMode
        ? await dummy.getRegistrationsForStudent(studentId)
        : await remote.getRegistrationsForStudent(studentId);
    return result.when(
      success: (dtos) => Success(dtos.map((dto) => dto.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
