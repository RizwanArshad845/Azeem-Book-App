import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/constants/app_routes.dart';
import 'core/di/injection.dart';
import 'core/di/riverpod_providers.dart';
import 'core/network/session/session_expiry_notifier.dart';
import 'core/router/app_router.dart';
import 'core/services/logger.dart';
import 'core/services/push_notification_service.dart';
import 'core/storage/local_cache_service.dart';
import 'core/widgets/app_crash_fallback.dart';
import 'presentation/auth/viewmodel/account_deleted_viewmodel.dart';
import 'domain/auth/entities/auth_session.dart';
import 'domain/auth/entities/user_role.dart';
import 'presentation/auth/viewmodel/auth_viewmodel.dart';
import 'presentation/notifications/viewmodel/notifications_viewmodel.dart';

void main() {
  runZonedGuarded(_runApp, (error, stack) {
    if (sl.isRegistered<Logger>()) {
      sl<Logger>().e('Uncaught zone error', error, stack);
    }
  });
}

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  // Friendly fallback instead of Flutter's default red/grey error screen
  // for any uncaught widget build error — only in release, so debug builds
  // keep the default screen (stack trace visible to developers).
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    sl<Logger>().e(
      'Uncaught Flutter framework error',
      details.exception,
      details.stack,
    );
  };
  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const AppCrashFallback();
  }

  await sl<LocalCacheService>().init();
  final container = ProviderContainer();
  // Registered so code that must read providers from OUTSIDE the provider
  // graph (e.g. `preloadTeacherProfileLookups`, which needs
  // `teacherOnboardingViewModelProvider` but is triggered from
  // `AuthViewModel` — reading it via `AuthViewModel`'s own `ref` creates a
  // real cycle back to `authViewModelProvider` via `currentUserProvider`)
  // can use `container.read(...)` instead, which isn't tied to any single
  // provider's dependency scope.
  sl.registerSingleton<ProviderContainer>(container);
  // Composition root: the only place allowed to wire core/network state
  // (a 401 came back) to a presentation/auth action (log the session out).
  SessionExpiryNotifier.onUnauthorized = () =>
      container.read(authViewModelProvider.notifier).logout();
  // `account_deleted`: show the blocking dialog; when it came back as a 401 on
  // the current session also clear the stored token/session (logout() is
  // local-only, so no refresh/retry — there is no refresh token). The router
  // redirect then returns the user to login.
  SessionExpiryNotifier.onAccountDeleted = ({required bool clearSession}) {
    container.read(accountDeletedEventProvider.notifier).notify();
    if (clearSession) {
      container.read(authViewModelProvider.notifier).logout();
    }
  };
  // `teacher_pending_approval` 403: the server is the authority — re-read the
  // routing status (-> `PENDING_APPROVAL`), and the router redirect moves the
  // teacher to the awaiting-approval screen. Concurrent 403s collapse inside
  // `refreshSessionStatus`.
  SessionExpiryNotifier.onTeacherPendingApproval = () {
    container.read(authViewModelProvider.notifier).refreshSessionStatus();
  };
  await _setUpPushNotifications(container);
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

Future<void> _setUpPushNotifications(ProviderContainer container) async {
  final push = sl<PushNotificationService>();
  await push.init(
    onMessage: (payload) => _onPushReceived(container, payload),
    onTap: (payload) {
      _onPushReceived(container, payload);
      _openNotifications(container);
    },
  );
  // A returning user (stored session) or a fresh login of an already
  // signed-up account. New accounts register from the signup flows instead,
  // once the account row exists.
  container.listen<AuthSession?>(currentUserProvider, (previous, next) {
    final userId = next?.userId;
    if (userId == null || next?.status == 'NOT_REGISTERED') return;
    if (previous?.userId != userId) unawaited(push.registerDevice());
  }, fireImmediately: true);
}

/// A push means a new notification exists server-side: refetch the list
/// (and the bell's unread count). `teacherApproved` also moves a pending
/// teacher straight on to the dashboard.
void _onPushReceived(ProviderContainer container, PushPayload payload) {
  final userId = container.read(currentUserProvider)?.userId;
  if (userId == null) return;
  container.read(notificationRepositoryProvider).clearCache(userId);
  container.invalidate(notificationsViewModelProvider);
  if (payload.type == 'teacherApproved') {
    unawaited(
      container.read(authViewModelProvider.notifier).refreshSessionStatus(),
    );
  }
}

void _openNotifications(ProviderContainer container) {
  final session = container.read(currentUserProvider);
  // Only from the dashboard — during signup/approval the router redirect
  // owns where the user is.
  if (session == null || session.status != 'DASHBOARD') return;
  container
      .read(goRouterProvider)
      .push(
        session.role == UserRole.teacher
            ? AppRoutes.teacherNotifications
            : AppRoutes.studentNotifications,
      );
}
