import '../../../core/storage/local_cache_service.dart';
import '../../../domain/common/result.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../../../domain/notifications/repositories/notification_repository.dart';
import '../../common/swr_repository_mixin.dart';
import '../datasources/remote/notification_remote_datasource.dart';
import '../models/notification_dto.dart';

/// Maps [NotificationRemoteDataSource] DTOs to domain entities so nothing
/// above this layer ever sees a DTO.
class NotificationRepositoryImpl
    with SwrRepositoryMixin
    implements NotificationRepository {
  NotificationRepositoryImpl({required this.remote, required this.cache});

  final NotificationRemoteDataSource remote;

  @override
  final LocalCacheService cache;

  final Map<String, List<Notification>> _cachedNotificationsByRecipient = {};

  String _cacheKeyFor(String recipientId) =>
      'cached_notifications_$recipientId';

  @override
  Future<Result<List<Notification>>> getNotifications(String recipientId) {
    return fetchListWithSwr<Notification>(
      cacheKey: _cacheKeyFor(recipientId),
      fromJson: (json) => NotificationDto.fromJson(json).toDomain(),
      toJson: (notif) => NotificationDto.fromDomain(notif).toJson(),
      // Most volatile of the SWR-cached repos — the unread badge count
      // directly depends on freshness, so this is mostly about an instant
      // paint followed by an almost-always-firing background revalidate.
      ttl: const Duration(minutes: 5),
      fetchRemote: () async {
        final result = await remote.getNotifications(recipientId);
        return result.when(
          success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
          failure: (f) => ResultFailure(f),
        );
      },
      getMemory: () => _cachedNotificationsByRecipient[recipientId],
      setMemory: (value) => _cachedNotificationsByRecipient[recipientId] = value,
    );
  }

  @override
  void clearCache(String recipientId) {
    _cachedNotificationsByRecipient.remove(recipientId);
    cache.remove(_cacheKeyFor(recipientId));
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
