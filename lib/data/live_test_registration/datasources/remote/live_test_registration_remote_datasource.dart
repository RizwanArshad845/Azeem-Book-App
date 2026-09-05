import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/result_guard.dart';
import '../../../../domain/common/result.dart';
import '../../models/live_test_registration_dto.dart';

/// Dio-backed live-test-registration datasource.
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
    return guardRequest(() async {
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
    return guardRequest(() async {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.liveTestRegistrationsForStudent(studentId),
      );
      return (response.data ?? const [])
          .map((e) => LiveTestRegistrationDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

}
