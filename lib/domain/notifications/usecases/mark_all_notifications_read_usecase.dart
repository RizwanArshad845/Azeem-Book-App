import '../../common/result.dart';
import '../repositories/notification_repository.dart';

/// Single-purpose use case: mark every notification for [recipientId] as read.
class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call(String recipientId) =>
      _repository.markAllAsRead(recipientId);
}
