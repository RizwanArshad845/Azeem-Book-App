import '../../common/result.dart';
import '../repositories/notification_repository.dart';

/// Single-purpose use case: remove/archive every notification for
/// [recipientId].
class ClearAllNotificationsUseCase {
  const ClearAllNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call(String recipientId) =>
      _repository.clearAll(recipientId);
}
