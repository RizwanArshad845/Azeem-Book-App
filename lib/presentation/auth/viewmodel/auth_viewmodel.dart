import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/usecases/logout_usecase.dart';
import '../../../domain/auth/usecases/request_otp_usecase.dart';
import '../../../domain/auth/usecases/verify_otp_usecase.dart';
import '../../../domain/common/failure.dart';

/// Generic role-select -> phone -> OTP-verify flow (§9.1/§9.2, §10.2).
/// Establishes "this phone number, verified via OTP, is acting as role X,
/// with session token Y." Does NOT know about Teacher/Student profile
/// completeness or router redirects — those land with teacher-onboarding /
/// student-onboarding in the next batch, reading `currentUserProvider`.
///
/// Note: this project's `pubspec.yaml` does not include `riverpod_generator`
/// / `riverpod_annotation` (only `flutter_riverpod`), so — consistent with
/// the existing `SplashViewModel` — this is a hand-written `AsyncNotifier`
/// with a manually declared provider rather than `@riverpod` codegen.
class AuthViewModel extends AsyncNotifier<AuthSession?> {
  UserRole? _selectedRole;
  String? _phoneNumber;

  @override
  Future<AuthSession?> build() async => null;

  /// Records which role this phone number is acting as. Called from
  /// `RoleSelectView` before navigating to phone entry.
  void selectRole(UserRole role) {
    _selectedRole = role;
  }

  /// Validates and submits [rawPhone] for OTP request.
  Future<bool> submitPhoneNumber(
    String rawPhone, {
    required String invalidPhoneMessage,
  }) async {
    final phone = rawPhone.trim();
    if (!Validators.isValidPhone10Digits(phone)) {
      state = AsyncError<AuthSession?>(
        ValidationFailure(invalidPhoneMessage),
        StackTrace.current,
      );
      return false;
    }
    return requestOtp(phone);
  }

  /// Requests an OTP for [phoneNumber] under the previously selected role.
  /// Returns `true` on success so the view can navigate to OTP entry.
  Future<bool> requestOtp(String phoneNumber) async {
    final role = _selectedRole;
    if (role == null) {
      state = AsyncError<AuthSession?>(
        const ValidationFailure('Select a role before requesting an OTP.'),
        StackTrace.current,
      );
      return false;
    }

    _phoneNumber = phoneNumber;
    state = const AsyncLoading<AuthSession?>();
    final result = await sl<RequestOtpUseCase>()(phoneNumber, role);
    return result.when(
      success: (session) {
        state = AsyncData<AuthSession?>(session);
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
  Future<void> verifyOtp(String otp) async {
    final role = _selectedRole;
    final phoneNumber = _phoneNumber;
    if (role == null || phoneNumber == null) {
      state = AsyncError<AuthSession?>(
        const ValidationFailure('Request an OTP before verifying it.'),
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

  /// Clears the current session.
  Future<void> logout() async {
    state = const AsyncLoading<AuthSession?>();
    final result = await sl<LogoutUseCase>()();
    state = result.when(
      success: (_) => const AsyncData<AuthSession?>(null),
      failure: (failure) => AsyncError<AuthSession?>(failure, StackTrace.current),
    );
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
