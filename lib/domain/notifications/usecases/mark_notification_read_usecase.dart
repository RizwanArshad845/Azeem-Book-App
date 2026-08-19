import '../../common/result.dart';
import '../repositories/notification_repository.dart';

/// Single-purpose use case: mark a single notification as read.
class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call(String notificationId) =>
      _repository.markAsRead(notificationId);
}
