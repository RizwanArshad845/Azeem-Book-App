import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/result_guard.dart';
import '../../../../domain/common/result.dart';
import '../../models/earnings_record_dto.dart';

/// Dio-backed earnings datasource. Read-only — `GET
/// /teachers/{id}/earnings` per `FRONTEND_INTEGRATION.md` §6.2; there is no
/// client-facing write endpoint (§6.5: records are created server-side on
/// checkout).
abstract class EarningsRemoteDataSource {
  Future<Result<List<EarningsRecordDto>>> getEarningsForTeacher(
    String teacherId,
  );
}

class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  EarningsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<List<EarningsRecordDto>>> getEarningsForTeacher(
    String teacherId,
  ) {
    return guardRequest(() async {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.teacherEarnings(teacherId),
      );
      return (response.data ?? const [])
          .map(
            (e) => EarningsRecordDto.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    });
  }
}
