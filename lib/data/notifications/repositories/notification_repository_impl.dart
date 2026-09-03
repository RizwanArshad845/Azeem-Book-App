import '../../../domain/common/result.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../../../domain/notifications/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_datasource.dart';

/// Maps [NotificationRemoteDataSource] DTOs to domain entities so nothing
/// above this layer ever sees a DTO.
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required this.remote});

  final NotificationRemoteDataSource remote;

  @override
  Future<Result<List<Notification>>> getNotifications(
    String recipientId,
  ) async {
    final result = await remote.getNotifications(recipientId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) {
    return remote.markAsRead(notificationId);
  }

  @override
  Future<Result<void>> markAllAsRead(String recipientId) {
    return remote.markAllAsRead(recipientId);
  }

  @override
  Future<Result<void>> clearAll(String recipientId) {
    return remote.clearAll(recipientId);
  }
}
