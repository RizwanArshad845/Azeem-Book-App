import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
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
    // Rebuild only when the logged-in user changes, not when just the
    // routing `status` is refreshed (see the teacherApproved check below).
    ref.watch(currentUserProvider.select((u) => u?.userId));
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return const [];
    }

    final result = await sl<GetNotificationsUseCase>()(user.userId!);
    final notifications = result.when(
      success: (notifications) => notifications,
      failure: (failure) => throw failure,
    );

    // An unread `teacherApproved` means an admin approved this teacher:
    // re-sync the routing status so a still-`PENDING_APPROVAL` session moves
    // on to the dashboard (no push yet — this is how the app finds out).
    if (user.status != 'DASHBOARD' &&
        notifications.any(
          (n) => n.type == NotificationType.teacherApproved && !n.isRead,
        )) {
      unawaited(ref.read(authViewModelProvider.notifier).refreshSessionStatus());
    }
    return notifications;
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
      success: (_) => ref
          .read(notificationRepositoryProvider)
          .clearCache(current.first.recipientId),
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
      success: (_) =>
          ref.read(notificationRepositoryProvider).clearCache(recipientId),
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
      success: (_) =>
          ref.read(notificationRepositoryProvider).clearCache(recipientId),
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
