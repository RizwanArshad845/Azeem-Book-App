import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/test_attempt_dto.dart';

/// Dio-backed submission datasource. Not exercised while
/// `AppConfig.isMockMode` is true, but must compile against the real
/// `ApiEndpoints`/`Dio` signatures so the eventual mock -> real swap is a
/// one-line config change (project_spec.md §6).
abstract class TestAttemptRemoteDataSource {
  Future<Result<TestAttemptDto>> submitAttempt(TestAttemptDto attempt);

  Future<Result<List<TestAttemptDto>>> getAttemptsForStudent(
    String studentId,
  );
}

class TestAttemptRemoteDataSourceImpl implements TestAttemptRemoteDataSource {
  TestAttemptRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<TestAttemptDto>> submitAttempt(TestAttemptDto attempt) {
    return _guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.testSubmit(attempt.testId),
        data: attempt.toJson(),
      );
      return TestAttemptDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<List<TestAttemptDto>>> getAttemptsForStudent(
    String studentId,
  ) {
    return _guard(() async {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.studentTestAttempts(studentId),
      );
      return (response.data ?? const [])
          .map((json) => TestAttemptDto.fromJson(json as Map<String, dynamic>))
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
