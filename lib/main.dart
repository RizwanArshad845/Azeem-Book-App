import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/network/session/session_expiry_notifier.dart';
import 'core/services/logger.dart';
import 'core/storage/local_cache_service.dart';
import 'core/widgets/app_crash_fallback.dart';
import 'presentation/auth/viewmodel/account_deleted_viewmodel.dart';
import 'presentation/auth/viewmodel/auth_viewmodel.dart';

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
    sl<Logger>().e('Uncaught Flutter framework error', details.exception, details.stack);
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
  SessionExpiryNotifier.onUnauthorized =
      () => container.read(authViewModelProvider.notifier).logout();
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
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
