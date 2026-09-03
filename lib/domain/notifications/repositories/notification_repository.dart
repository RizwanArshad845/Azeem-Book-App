import '../../common/result.dart';
import '../entities/notification.dart';

/// Zero Flutter/Riverpod/package dependencies per §2 Clean Architecture
/// rules. Shared between the Student and Teacher Notifications tabs
/// (§10.2) — both filter by `recipientId` only.
abstract class NotificationRepository {
  /// Fetches all notifications addressed to [recipientId], newest first.
  Future<Result<List<Notification>>> getNotifications(String recipientId);

  /// Marks [notificationId] as read.
  Future<Result<void>> markAsRead(String notificationId);

  /// Marks every notification addressed to [recipientId] as read.
  Future<Result<void>> markAllAsRead(String recipientId);

  /// Removes/archives every notification addressed to [recipientId].
  Future<Result<void>> clearAll(String recipientId);
}
