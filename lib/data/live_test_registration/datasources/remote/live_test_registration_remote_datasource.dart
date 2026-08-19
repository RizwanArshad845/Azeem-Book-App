import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/live_test_registration_dto.dart';

/// Dio-backed live-test-registration datasource. Not exercised while
/// `AppConfig.isMockMode` is true, but must compile against the real
/// `ApiEndpoints`/`Dio` signatures so the eventual mock -> real swap is a
/// one-line config change (project_spec.md §6), matching
/// `CartRemoteDataSource`'s pattern.
abstract class LiveTestRegistrationRemoteDataSource {
  Future<Result<LiveTestRegistrationDto>> register(
    String studentId,
    String testId,
  );

  Future<Result<List<LiveTestRegistrationDto>>> getRegistrationsForStudent(
    String studentId,
  );
}

class LiveTestRegistrationRemoteDataSourceImpl
    implements LiveTestRegistrationRemoteDataSource {
  LiveTestRegistrationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<LiveTestRegistrationDto>> register(
    String studentId,
    String testId,
  ) {
    return _guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.liveTestRegister,
        data: {'studentId': studentId, 'testId': testId},
      );
      return LiveTestRegistrationDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<List<LiveTestRegistrationDto>>> getRegistrationsForStudent(
    String studentId,
  ) {
    return _guard(() async {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.liveTestRegistrationsForStudent(studentId),
      );
      return (response.data ?? const [])
          .map((e) => LiveTestRegistrationDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Success(await body());
    } on DioException catch (e) {
      final failure = e.error;
      return ResultFailure(
        failure is Failure ? failure : UnknownFailure(e.message),
      );
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
