import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/common/failure.dart';

/// State for the custom-callback OTP verify flow (phone-change, etc.).
///
/// Used only when [OtpVerifyView] is opened with an explicit [onVerifyCode]
/// callback — the default auth login flow still drives itself from
/// [authViewModelProvider].
class OtpVerifyState {
  const OtpVerifyState({
    this.isLoading = false,
    this.isVerified = false,
    this.failure,
    this.resetToken = 0,
  });

  final bool isLoading;
  final bool isVerified;
  final Failure? failure;

  /// Incremented on each failed attempt so [OtpDigitBox] clears itself.
  final int resetToken;

  OtpVerifyState copyWith({
    bool? isLoading,
    bool? isVerified,
    Failure? failure,
    bool clearFailure = false,
    int? resetToken,
  }) {
    return OtpVerifyState(
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      failure: clearFailure ? null : (failure ?? this.failure),
      resetToken: resetToken ?? this.resetToken,
    );
  }
}

/// ViewModel for the custom-callback OTP verify flow.
///
/// Created with [autoDispose] so each bottom-sheet / page instance gets its
/// own fresh state and it is automatically cleaned up when dismissed.
class OtpVerifyViewModel extends Notifier<OtpVerifyState> {
  @override
  OtpVerifyState build() => const OtpVerifyState();

  /// Delegates verification to the caller-supplied [onVerifyCode] callback and
  /// reflects loading / success / error into [state].
  ///
  /// Returns `void` — all async work is fire-and-forget inside the viewmodel.
  void verify(
    String code,
    Future<Failure?> Function(String code) onVerifyCode,
  ) {
    _verify(code, onVerifyCode);
  }

  Future<void> _verify(
    String code,
    Future<Failure?> Function(String code) onVerifyCode,
  ) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final failure = await onVerifyCode(code);
    if (failure == null) {
      state = state.copyWith(isLoading: false, isVerified: true);
    } else {
      state = state.copyWith(
        isLoading: false,
        failure: failure,
        resetToken: state.resetToken + 1,
      );
    }
  }

  /// Reflects a resend-loading pulse into state (timer / snackbar are still
  /// handled in the view, which has access to [BuildContext]).
  void setResendLoading({required bool value}) {
    state = state.copyWith(isLoading: value);
  }
}

final otpVerifyViewModelProvider =
    NotifierProvider.autoDispose<OtpVerifyViewModel, OtpVerifyState>(
      OtpVerifyViewModel.new,
    );
