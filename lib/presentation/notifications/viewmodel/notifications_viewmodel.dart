import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../../../domain/notifications/usecases/get_notifications_usecase.dart';
import '../../../domain/notifications/usecases/mark_notification_read_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

/// Shared backing for both the Student and Teacher Notifications tabs
/// (§10.2) — filters purely by the logged-in user's `recipientId` via
/// `currentUserProvider`, so one viewmodel/view pair serves both roles.
///
/// Note: this project's `pubspec.yaml` does not include `riverpod_generator`
/// / `riverpod_annotation` (only `flutter_riverpod`), so — consistent with
/// `AuthViewModel` — this is a hand-written `AsyncNotifier` with a manually
/// declared provider rather than `@riverpod` codegen.
class NotificationsViewModel extends AsyncNotifier<List<Notification>> {
  @override
  Future<List<Notification>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      // Edge case only — router redirect guarantees a resolved session
      // before either shell is reachable.
      return const [];
    }

    final result = await sl<GetNotificationsUseCase>()(user.userId);
    return result.when(
      success: (notifications) => notifications,
      failure: (failure) => throw failure,
    );
  }

  /// Marks [notificationId] as read. Optimistically updates local state so
  /// the UI reflects the tap immediately, then confirms with the use case;
  /// rolls back to the previous state if that call fails.
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
        // Roll back the optimistic update on failure.
        state = AsyncData<List<Notification>>(current);
      },
    );
  }
}

final notificationsViewModelProvider =
    AsyncNotifierProvider<NotificationsViewModel, List<Notification>>(
      NotificationsViewModel.new,
    );
