import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/push_notification_service.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/usecases/get_stored_session_usecase.dart';
import '../../../domain/auth/usecases/logout_usecase.dart';
import '../../../domain/auth/usecases/refresh_session_status_usecase.dart';
import '../../../domain/auth/usecases/sign_in_with_google_usecase.dart';
import '../../../domain/common/result.dart';
import '../../../domain/ebook_offline/repositories/ebook_offline_repository.dart';
import '../../ebook_reader/ebook_page_cache.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../../teacher_profile/viewmodel/teacher_profile_catalog_providers.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart'
    show teacherStudentsCampusesByIdProvider;

/// An app-wide auth action in progress, shown as a blocking loader over the
/// whole app (`App` builder) so the user knows to wait and can't tap twice.
enum AuthBusy { none, signingIn, loggingOut }

class AuthBusyNotifier extends Notifier<AuthBusy> {
  @override
  AuthBusy build() => AuthBusy.none;

  void set(AuthBusy value) => state = value;
}

final authBusyProvider =
    NotifierProvider<AuthBusyNotifier, AuthBusy>(AuthBusyNotifier.new);

class AuthViewModel extends AsyncNotifier<AuthSession?> {
  UserRole? _selectedRole;

  void _setBusy(AuthBusy value) => ref.read(authBusyProvider.notifier).set(value);

  @override
  Future<AuthSession?> build() async {
    final result = await sl<GetStoredSessionUseCase>()();
    return result.when(success: (session) => session, failure: (_) => null);
  }

  /// Records which role the user is signing in as. Called from
  /// `RoleSelectView` before navigating to the Google sign-in screen.
  void selectRole(UserRole role) {
    _selectedRole = role;
  }

  UserRole get selectedRole => _selectedRole ?? UserRole.student;

  /// Runs Google Sign-In for the selected role and exchanges the result for
  /// a backend session. Deliberately does not signal navigation — the router
  /// redirect reacts to the session landing in `state`. Dismissing Google's
  /// account picker just leaves the user on the sign-in screen (state back
  /// to `null`, no error).
  Future<void> signInWithGoogle() async {
    if (ref.read(authBusyProvider) != AuthBusy.none) return;
    final role = selectedRole;
    state = const AsyncLoading<AuthSession?>();
    _setBusy(AuthBusy.signingIn);

    final Result<AuthSession?> result;
    try {
      result = await sl<SignInWithGoogleUseCase>()(role);
    } finally {
      _setBusy(AuthBusy.none);
    }
    state = result.when(
      success: (session) => AsyncData<AuthSession?>(session),
      failure: (failure) =>
          AsyncError<AuthSession?>(failure, StackTrace.current),
    );

    if (result.isSuccess && state.value != null) {
      // Fire the role-agnostic catalog lookups (campus/board-class/
      // class-level) immediately after login succeeds, instead of only
      // starting them once a screen first watches them. Deliberately NOT
      // fired before sign-in resolves: these endpoints require an auth
      // token, so calling them any earlier guarantees a 401 — and since
      // they're plain (non-`.autoDispose`) `FutureProvider`s with no prior
      // cache on a fresh login, a pre-auth 401 permanently poisons them into
      // `AsyncError` for the rest of the app session.
      unawaited(_prefetchLoginCatalogData());
      if (role == UserRole.teacher) {
        unawaited(preloadTeacherProfileLookups());
      }
    }
  }

  bool _refreshingStatus = false;

  /// Re-fetches the routing status (`GET /auth/session-status`) and, if it
  /// changed, swaps it into the current session so the router redirect
  /// re-evaluates (e.g. `PENDING_APPROVAL` -> `DASHBOARD` after an admin
  /// approves a teacher). Returns the status the backend reported, or `null`
  /// if there is no session or the call failed (the session is left as-is).
  /// Concurrent calls collapse into one (returns `null` for the extras).
  Future<String?> refreshSessionStatus() async {
    if (_refreshingStatus || state.value == null) return null;
    _refreshingStatus = true;
    try {
      final result = await sl<RefreshSessionStatusUseCase>()();
      final status = result.when(
        success: (status) => status,
        failure: (_) => null,
      );
      if (status != null) setSessionStatus(status);
      return status;
    } finally {
      _refreshingStatus = false;
    }
  }

  /// Updates only the `status` of the current session (no-op if unchanged or
  /// signed out). In-memory; [refreshSessionStatus] also persists.
  void setSessionStatus(String status) {
    final current = state.value;
    if (current == null || current.status == status) return;
    state = AsyncData<AuthSession?>(current.copyWith(status: status));
  }

  /// Kicks off the role-agnostic catalog lookups (campus/board-class/
  /// class-level) right after login succeeds, so they have a head start
  /// before any screen first watches them.
  Future<void> _prefetchLoginCatalogData() async {
    try {
      await Future.wait([
        ref.read(campusesProvider.future),
        ref.read(boardClassesProvider.future),
        ref.read(classLevelsProvider.future),
      ]);
    } catch (_) {
      // Ignore — this is only a head start; consumers fetch normally on
      // first watch if this failed.
    }
  }

  /// Clears the current session, and force-resets every other provider that
  /// caches "who is the current user" data derived from it. Without this,
  /// a previous user's cached `Student`/`Teacher` survives in this
  /// process-lifetime `ProviderContainer` (`lib/main.dart`) and gets shown
  /// to the next different user who logs in.
  ///
  /// Uses `sl<ProviderContainer>()`, NOT `ref.invalidate(...)` on this
  /// Notifier's own `ref` — confirmed via a real device log that the latter
  /// throws `CircularDependencyError` every time (same root cause as
  /// `preloadTeacherProfileLookups`'s fix above: both
  /// `studentOnboardingViewModelProvider` and `teacherOnboardingViewModelProvider`
  /// watch `currentUserProvider`, which watches `authViewModelProvider`, so
  /// invalidating them from `authViewModelProvider`'s own element is a real
  /// graph cycle). This means logout has never actually cleared this cache
  /// until now — a stale previous session's Teacher/Student data was
  /// silently surviving every logout.
  Future<void> logout() async {
    // A second tap (or a second entry point) while one is running is a no-op.
    if (ref.read(authBusyProvider) == AuthBusy.loggingOut) return;
    _setBusy(AuthBusy.loggingOut);
    try {
      await _logout();
    } finally {
      _setBusy(AuthBusy.none);
    }
  }

  Future<void> _logout() async {
    // Before the session token is cleared: the request needs it. Best-effort
    // and time-boxed so a bad connection can't trap the user in the loader.
    try {
      await sl<PushNotificationService>()
          .unregisterDevice()
          .timeout(const Duration(seconds: 8));
    } catch (_) {}
    state = const AsyncLoading<AuthSession?>();
    final result = await sl<LogoutUseCase>()();
    state = result.when(
      success: (_) => const AsyncData<AuthSession?>(null),
      failure: (failure) =>
          AsyncError<AuthSession?>(failure, StackTrace.current),
    );
    if (state.hasValue && state.value == null) {
      final container = sl<ProviderContainer>();
      container.invalidate(studentOnboardingViewModelProvider);
      container.invalidate(teacherOnboardingViewModelProvider);
      // Purchased content must not outlive the account on this device:
      // wipe encrypted offline ebooks (and their keys) plus the streamed
      // page cache. Best-effort — a storage error must not block logout.
      try {
        await sl<EbookOfflineRepository>().removeAll();
        await ebookPageCacheManager.emptyCache();
      } catch (_) {}
    }
  }
}

final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, AuthSession?>(AuthViewModel.new);

/// Read-only session accessor other features (teacher/student onboarding,
/// router redirect) will depend on without coupling to the auth
/// viewmodel's full async lifecycle.
final currentUserProvider = Provider<AuthSession?>((ref) {
  return ref.watch(authViewModelProvider.select((async) => async.value));
});

/// Warms the Teacher Profile "Teaching Scope" card's catalog lookups so the
/// card never renders raw subject/campus ids before rebuilding with
/// resolved names. Called from `AuthViewModel.signInWithGoogle()` right after a
/// fresh teacher login succeeds.
///
/// Uses `sl<ProviderContainer>()` (registered in `main.dart`) instead of
/// `AuthViewModel`'s own `ref`. This is not optional: `AuthViewModel`'s
/// `ref` stays scoped to `authViewModelProvider` for the Notifier's entire
/// lifetime (not just during `build()`), so reading
/// `teacherOnboardingViewModelProvider` through it — which itself watches
/// `currentUserProvider`, which watches `authViewModelProvider` — creates a
/// real graph cycle: `authViewModelProvider` -> `teacherOnboardingViewModelProvider`
/// -> `currentUserProvider` -> back to `authViewModelProvider`. Confirmed via
/// a real device log: this threw `CircularDependencyError` immediately (10ms
/// in) on every call, silently no-opping the entire prefetch. A
/// `ProviderContainer.read()` isn't tied to any single provider's dependency
/// scope, so it can read this chain without triggering the cycle detector.
Future<void> preloadTeacherProfileLookups() async {
  final container = sl<ProviderContainer>();
  try {
    final teacher = await container
        .read(teacherOnboardingViewModelProvider.future)
        .timeout(const Duration(seconds: 4));
    if (teacher == null) return;
    await Future.wait([
      container.read(teacherProfileBoardClassesByIdProvider.future),
      container.read(teacherProfileClassLevelsByIdProvider.future),
      container.read(teacherProfileResolvedSubjectsProvider.future),
      container.read(teacherStudentsCampusesByIdProvider.future),
    ]).timeout(const Duration(seconds: 4));
  } catch (_) {
    // Graceful fallback: a slow/failed prefetch shouldn't affect login —
    // the card just falls back to resolving lookups on first watch.
  }
}
