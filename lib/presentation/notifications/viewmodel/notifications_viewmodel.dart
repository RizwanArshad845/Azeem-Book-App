import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../../../domain/notifications/usecases/clear_all_notifications_usecase.dart';
import '../../../domain/notifications/usecases/get_notifications_usecase.dart';
import '../../../domain/notifications/usecases/mark_all_notifications_read_usecase.dart';
import '../../../domain/notifications/usecases/mark_notification_read_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

/// Shared backing for both the Student and Teacher Notifications tabs
class NotificationsViewModel extends AsyncNotifier<List<Notification>> {
  @override
  Future<List<Notification>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const [];
    }

    final result = await sl<GetNotificationsUseCase>()(user.userId!);
    return result.when(
      success: (notifications) => notifications,
      failure: (failure) => throw failure,
    );
  }

  /// Marks [notificationId] as read.
  Future<void> markAsRead(String notificationId) async {
    final current = state.value;
    if (current == null) return;

    final alreadyRead = current
        .where((n) => n.id == notificationId)
        .any((n) => n.isRead);
    if (alreadyRead) return;

    state = AsyncData<List<Notification>>([
      for (final notification in current)
        if (notification.id == notificationId)
          notification.copyWith(isRead: true)
        else
          notification,
    ]);

    final result = await sl<MarkNotificationReadUseCase>()(notificationId);
    result.when(
      success: (_) {},
      failure: (_) {
        state = AsyncData<List<Notification>>(current);
      },
    );
  }

  /// Marks all current notifications as read.
  Future<void> markAllAsRead() async {
    final current = state.value;
    final recipientId = ref.read(currentUserProvider)?.userId;
    if (current == null || current.isEmpty || recipientId == null) return;

    state = AsyncData<List<Notification>>([
      for (final n in current) n.copyWith(isRead: true),
    ]);

    final result = await sl<MarkAllNotificationsReadUseCase>()(recipientId);
    result.when(
      success: (_) {},
      failure: (_) {
        state = AsyncData<List<Notification>>(current);
      },
    );
  }

  /// Clears all notifications server-side.
  Future<void> clearAll() async {
    final current = state.value;
    final recipientId = ref.read(currentUserProvider)?.userId;
    if (recipientId == null) return;

    state = const AsyncData<List<Notification>>([]);

    final result = await sl<ClearAllNotificationsUseCase>()(recipientId);
    result.when(
      success: (_) {},
      failure: (_) {
        if (current != null) {
          state = AsyncData<List<Notification>>(current);
        }
      },
    );
  }
}

final notificationsViewModelProvider =
    AsyncNotifierProvider<NotificationsViewModel, List<Notification>>(
      NotificationsViewModel.new,
    );
