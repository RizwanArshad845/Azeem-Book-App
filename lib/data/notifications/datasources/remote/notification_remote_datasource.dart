import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/notification_dto.dart';

/// Dio-backed notifications datasource. Not exercised while
/// `AppConfig.isMockMode` is true, but must compile against the real
/// `ApiEndpoints`/`Dio` signatures so the eventual mock -> real swap is a
/// one-line config change (project_spec.md §6).
abstract class NotificationRemoteDataSource {
  Future<Result<List<NotificationDto>>> getNotifications(String recipientId);

  Future<Result<void>> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<List<NotificationDto>>> getNotifications(
    String recipientId,
  ) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.notifications(recipientId),
      );
      final items = (response.data ?? <dynamic>[])
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(items);
    } on DioException catch (e) {
      final failure = e.error;
      return ResultFailure(
        failure is Failure ? failure : UnknownFailure(e.message),
      );
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      await _dio.post<void>(ApiEndpoints.notificationMarkRead(notificationId));
      return const Success(null);
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
