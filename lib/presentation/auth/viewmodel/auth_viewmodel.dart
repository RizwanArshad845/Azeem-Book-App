import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/usecases/get_stored_session_usecase.dart';
import '../../../domain/auth/usecases/logout_usecase.dart';
import '../../../domain/auth/usecases/request_otp_usecase.dart';
import '../../../domain/auth/usecases/verify_otp_usecase.dart';
import '../../../domain/common/failure.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../../teacher_profile/viewmodel/teacher_profile_catalog_providers.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart'
    show teacherStudentsCampusesByIdProvider;


class AuthViewModel extends AsyncNotifier<AuthSession?> {
  UserRole? _selectedRole;
  String? _phoneNumber;

  @override
  Future<AuthSession?> build() async {
    final result = await sl<GetStoredSessionUseCase>()();
    return result.when(
      success: (session) => session,
      failure: (_) => null,
    );
  }

  /// Records which role this phone number is acting as. Called from
  /// `RoleSelectView` before navigating to phone entry.
  void selectRole(UserRole role) {
    _selectedRole = role;
  }

  /// Validates and submits [rawPhone] for OTP request.
  Future<bool> submitPhoneNumber(
    String rawPhone, {
    required String invalidPhoneMessage,
    String? roleRequiredMessage,
  }) async {
    final phone = rawPhone.trim();
    if (!Validators.isValidPhoneLocal(phone)) {
      state = AsyncError<AuthSession?>(
        ValidationFailure(invalidPhoneMessage),
        StackTrace.current,
      );
      return false;
    }
    return requestOtp(phone, roleRequiredMessage: roleRequiredMessage);
  }

  UserRole get selectedRole => _selectedRole ?? UserRole.student;

  /// Requests an OTP for [phoneNumber] under the previously selected role.
  /// Returns `true` on success so the view can navigate to OTP entry.
  Future<bool> requestOtp(
    String phoneNumber, {
    String? roleRequiredMessage,
  }) async {
    final role = selectedRole;

    _phoneNumber = phoneNumber;
    state = const AsyncLoading<AuthSession?>();
    final result = await sl<RequestOtpUseCase>()(phoneNumber, role);
    return result.when(
      success: (_) {
        // Deliberately does NOT store the returned (unverified, `token:
        // null`) session in `state` — `currentUserProvider` reads `state`
        // as "is anyone logged in," and the router/onboarding viewmodels
        // treat any non-null value as a green light to navigate away from
        // the auth flow. Doing that here — before the OTP is actually
        // verified — was kicking the user off the phone-entry screen (and
        // dismissing the OTP bottom sheet with it) the instant an OTP was
        // merely requested. `_phoneNumber`/`_selectedRole` already carry
        // everything `verifyOtp` needs, so `state` can just stay `null`
        // until a real, verified session exists.
        state = const AsyncData<AuthSession?>(null);
        return true;
      },
      failure: (failure) {
        state = AsyncError<AuthSession?>(failure, StackTrace.current);
        return false;
      },
    );
  }

  /// Verifies [otp] against the phone number/role recorded by
  /// [requestOtp]. Deliberately does not signal navigation — callers should
  /// simply let this `AsyncValue` resolve (§ task scope: router redirect is
  /// wired in a later batch).
  Future<void> verifyOtp(
    String otp, {
    String? otpRequiredMessage,
  }) async {
    final role = _selectedRole;
    final phoneNumber = _phoneNumber;
    if (role == null || phoneNumber == null) {
      state = AsyncError<AuthSession?>(
        ValidationFailure(
          otpRequiredMessage ?? 'Request an OTP before verifying it.',
        ),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading<AuthSession?>();

    final result = await sl<VerifyOtpUseCase>()(phoneNumber, otp, role);
    state = result.when(
      success: (session) => AsyncData<AuthSession?>(session),
      failure: (failure) => AsyncError<AuthSession?>(failure, StackTrace.current),
    );

    if (result.isSuccess) {
      // Fire the role-agnostic catalog lookups (campus/board-class/
      // class-level) immediately after login succeeds, instead of only
      // starting them once a screen first watches them. Deliberately NOT
      // fired before `VerifyOtpUseCase` resolves: these endpoints require
      // an auth token, so calling them any earlier than this guarantees a
      // 401 — and since they're plain (non-`.autoDispose`) `FutureProvider`s
      // with no prior cache on a fresh login, a pre-auth 401 permanently
      // poisons them into `AsyncError` for the rest of the app session
      // (confirmed via a real device log capture: this exact 401 storm was
      // the actual root cause of the Teacher Profile card's raw-id flash —
      // its lookups depend on these same providers, which never recovered
      // after being poisoned).
      unawaited(_prefetchLoginCatalogData());
      if (role == UserRole.teacher) {
        unawaited(preloadTeacherProfileLookups());
      }
    }
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
    state = const AsyncLoading<AuthSession?>();
    final result = await sl<LogoutUseCase>()();
    state = result.when(
      success: (_) => const AsyncData<AuthSession?>(null),
      failure: (failure) => AsyncError<AuthSession?>(failure, StackTrace.current),
    );
    if (state.hasValue && state.value == null) {
      final container = sl<ProviderContainer>();
      container.invalidate(studentOnboardingViewModelProvider);
      container.invalidate(teacherOnboardingViewModelProvider);
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
/// resolved names. Called from `AuthViewModel.verifyOtp()` right after a
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
