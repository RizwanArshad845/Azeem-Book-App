import '../../../core/config/app_config.dart';
import '../../../domain/common/result.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../../../domain/notifications/repositories/notification_repository.dart';
import '../datasources/local/notification_dummy_datasource.dart';
import '../datasources/remote/notification_remote_datasource.dart';

/// Switches between [NotificationRemoteDataSource] and
/// [NotificationDummyDataSource] based on `AppConfig.isMockMode`
/// (project_spec.md §6.2) and maps DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.remote,
    required this.dummy,
    this.isMockMode = AppConfig.isMockMode,
  });

  final NotificationRemoteDataSource remote;
  final NotificationDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<List<Notification>>> getNotifications(
    String recipientId,
  ) async {
    final result = isMockMode
        ? await dummy.getNotifications(recipientId)
        : await remote.getNotifications(recipientId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) {
    return isMockMode
        ? dummy.markAsRead(notificationId)
        : remote.markAsRead(notificationId);
  }
}
