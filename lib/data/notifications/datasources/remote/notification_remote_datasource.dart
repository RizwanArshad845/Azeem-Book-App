import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/result_guard.dart';
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
  ) {
    return guardRequest(() async {
      // Paginated DRF envelope (`{count, next, previous, results}`), not a
      // bare array — only the first page (default size 20) is fetched here.
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.notifications(recipientId),
      );
      final results = response.data?['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) {
    return guardRequest(() async {
      await _dio.post<void>(ApiEndpoints.notificationMarkRead(notificationId));
    });
  }

  @override
  Future<Result<void>> markAllAsRead(String recipientId) {
    return guardRequest(() async {
      await _dio.post<void>(ApiEndpoints.notificationsReadAll(recipientId));
    });
  }

  @override
  Future<Result<void>> clearAll(String recipientId) {
    return guardRequest(() async {
      await _dio.delete<void>(ApiEndpoints.notificationsClearAll(recipientId));
    });
  }
}
