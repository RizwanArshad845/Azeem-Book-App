import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/earnings_record_dto.dart';

/// Dio-backed earnings datasource.
///
/// Reuses the existing `ApiEndpoints.teacherEarnings(teacherId)` path for
/// both reads (`GET`) and the create-on-purchase write (`POST`) — no new
/// endpoint needed, matching how `CartRemoteDataSource` reuses
/// `studentCart` for both add/remove.
abstract class EarningsRemoteDataSource {
  Future<Result<EarningsRecordDto>> recordEarnings(EarningsRecordDto draft);

  Future<Result<List<EarningsRecordDto>>> getEarningsForTeacher(
    String teacherId,
  );
}

class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  EarningsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<EarningsRecordDto>> recordEarnings(EarningsRecordDto draft) {
    return _guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.teacherEarnings(draft.teacherId ?? ''),
        data: draft.toJson(),
      );
      return EarningsRecordDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<List<EarningsRecordDto>>> getEarningsForTeacher(
    String teacherId,
  ) {
    return _guard(() async {
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
