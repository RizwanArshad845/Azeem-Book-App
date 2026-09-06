import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';

/// Resend-cooldown/attempt-count state for the OTP bottom sheet. A plain
/// (non-freezed) immutable class — three primitive fields don't warrant
/// codegen, mirroring `SubjectSelectionViewModel`'s hand-rolled `Map` state
/// in `student_onboarding_viewmodel.dart`.
class OtpTimerState {
  const OtpTimerState({
    this.phoneNumber,
    this.secondsRemaining = 0,
    this.attemptCount = 0,
  });

  final String? phoneNumber;
  final int secondsRemaining;
  final int attemptCount;

  bool get canRequestNow => secondsRemaining <= 0;

  bool get attemptLimitReached =>
      attemptCount >= AppConfig.otpMaxResendAttempts;

  OtpTimerState copyWith({
    String? phoneNumber,
    int? secondsRemaining,
    int? attemptCount,
  }) {
    return OtpTimerState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }
}

/// Client-side-only resend cooldown for the OTP bottom sheet (§10.2 OTP
/// sheet). This is a UX throttle to stop an accidental duplicate SMS send
/// when a user dismisses/reopens the sheet — **not** a security control:
/// there is no backend rate-limit enforcement behind it, and an app
/// restart resets it. Real abuse prevention is a backend concern outside
/// this repo.
///
/// Deliberately a separate provider from `authViewModelProvider` (and
/// deliberately *not* `.autoDispose`, so it survives the bottom sheet being
/// dismissed and reopened): `authViewModelProvider` is watched broadly
/// (router redirects, etc.), so a 1-second tick inside it would cause
/// unrelated app-wide rebuilds. Mirrors the `Timer.periodic`-inside-a-
/// notifier idiom from `TestTakingViewModel._startTimer()`
/// (`lib/presentation/test_taking/viewmodel/test_taking_viewmodel.dart`).
class OtpTimerViewModel extends Notifier<OtpTimerState> {
  Timer? _timer;

  @override
  OtpTimerState build() {
    ref.onDispose(() => _timer?.cancel());
    return const OtpTimerState();
  }

  /// Starts (or restarts) the cooldown after an OTP request/resend for
  /// [phoneNumber]. The attempt count carries over across restarts for the
  /// same number, and resets for a different one (a fresh number gets a
  /// fresh cap).
  void startCooldown(String phoneNumber) {
    final sameNumber = state.phoneNumber == phoneNumber;
    state = OtpTimerState(
      phoneNumber: phoneNumber,
      secondsRemaining: AppConfig.otpResendCooldownSeconds,
      attemptCount: (sameNumber ? state.attemptCount : 0) + 1,
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsRemaining <= 1) {
        _timer?.cancel();
        state = state.copyWith(secondsRemaining: 0);
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    });
  }
}

final otpTimerViewModelProvider =
    NotifierProvider<OtpTimerViewModel, OtpTimerState>(OtpTimerViewModel.new);
