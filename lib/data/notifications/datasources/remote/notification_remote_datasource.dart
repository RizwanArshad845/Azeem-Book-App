import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/notification_dto.dart';

/// Dio-backed notifications datasource.
abstract class NotificationRemoteDataSource {
  Future<Result<List<NotificationDto>>> getNotifications(String recipientId);

  Future<Result<void>> markAsRead(String notificationId);

  /// Marks every notification addressed to [recipientId] as read
  /// (`backend.md` §4.7).
  Future<Result<void>> markAllAsRead(String recipientId);

  /// Removes/archives every notification addressed to [recipientId]
  /// (`backend.md` §4.7).
  Future<Result<void>> clearAll(String recipientId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<List<NotificationDto>>> getNotifications(
    String recipientId,
  ) async {
    try {
      // Paginated DRF envelope (`{count, next, previous, results}`), not a
      // bare array — only the first page (default size 20) is fetched here.
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.notifications(recipientId),
      );
      final results = response.data?['results'] as List<dynamic>? ?? [];
      final items = results
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

  @override
  Future<Result<void>> markAllAsRead(String recipientId) async {
    try {
      await _dio.post<void>(ApiEndpoints.notificationsReadAll(recipientId));
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

  @override
  Future<Result<void>> clearAll(String recipientId) async {
    try {
      await _dio.delete<void>(ApiEndpoints.notificationsClearAll(recipientId));
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
