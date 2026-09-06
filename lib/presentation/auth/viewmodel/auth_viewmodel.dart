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
  }

  /// Clears the current session, and force-resets every other provider that
  /// caches "who is the current user" data derived from it. Without this,
  /// a previous user's cached `Student`/`Teacher` survives in this
  /// process-lifetime `ProviderContainer` (`lib/main.dart`) and gets shown
  /// to the next different user who logs in.
  Future<void> logout() async {
    state = const AsyncLoading<AuthSession?>();
    final result = await sl<LogoutUseCase>()();
    state = result.when(
      success: (_) => const AsyncData<AuthSession?>(null),
      failure: (failure) => AsyncError<AuthSession?>(failure, StackTrace.current),
    );
    if (state.hasValue && state.value == null) {
      ref.invalidate(studentOnboardingViewModelProvider);
      ref.invalidate(teacherOnboardingViewModelProvider);
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
