import '../../common/result.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

/// Single-purpose use case: fetch all notifications for a recipient.
class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<List<Notification>>> call(String recipientId) =>
      _repository.getNotifications(recipientId);
}
