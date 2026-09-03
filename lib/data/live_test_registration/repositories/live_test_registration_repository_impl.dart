import '../../../domain/common/result.dart';
import '../../../domain/live_test_registration/entities/live_test_registration.dart';
import '../../../domain/live_test_registration/repositories/live_test_registration_repository.dart';
import '../datasources/remote/live_test_registration_remote_datasource.dart';

/// Maps [LiveTestRegistrationRemoteDataSource] DTOs to domain entities so
/// nothing above this layer ever sees a DTO.
class LiveTestRegistrationRepositoryImpl
    implements LiveTestRegistrationRepository {
  LiveTestRegistrationRepositoryImpl({required this.remote});

  final LiveTestRegistrationRemoteDataSource remote;

  @override
  Future<Result<LiveTestRegistration>> registerForLiveTest({
    required String studentId,
    required String testId,
  }) async {
    final result = await remote.register(studentId, testId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<LiveTestRegistration>>> getRegistrationsForStudent(
    String studentId,
  ) async {
    final result = await remote.getRegistrationsForStudent(studentId);
    return result.when(
      success: (dtos) => Success(dtos.map((dto) => dto.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
