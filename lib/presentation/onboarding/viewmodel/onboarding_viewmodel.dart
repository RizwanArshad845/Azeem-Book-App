import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/onboarding/entities/class_level.dart';
import '../state/onboarding_state.dart';

class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void setPhone(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  /// Returns true if [code] matches the hardcoded OTP. On the 3rd wrong
  /// attempt, locks the sheet — caller is expected to auto-restart the flow
  /// back to the phone screen after the cooldown via [resetOtp].
  bool verifyOtp(String code) {
    if (code == AppConfig.otpCode) {
      state = state.copyWith(otpVerified: true, otpAttempts: 0, otpLocked: false);
      return true;
    }
    final attempts = state.otpAttempts + 1;
    state = state.copyWith(
      otpAttempts: attempts,
      otpLocked: attempts >= AppConfig.otpMaxAttempts,
    );
    return false;
  }

  void resetOtp() {
    state = state.copyWith(otpAttempts: 0, otpLocked: false);
  }

  void setPersonalInfo({
    required String name,
    required String city,
    required String college,
    required ClassLevel classLevel,
    String classCode = '',
  }) {
    state = state.copyWith(
      name: name,
      city: city,
      college: college,
      classLevel: classLevel,
      classCode: classCode,
    );
  }

  void setSubjectCount(int count) {
    final clamped =
        count.clamp(AppConfig.subjectCountMin, AppConfig.subjectCountMax);
    final subjects = List<String>.generate(
      clamped,
      (i) => i < state.subjects.length ? state.subjects[i] : '',
    );
    state = state.copyWith(subjectCount: clamped, subjects: subjects);
  }

  void setSubjectAt(int index, String subject) {
    if (index < 0 || index >= state.subjects.length) return;
    final updated = [...state.subjects];
    updated[index] = subject;
    state = state.copyWith(subjects: updated);
  }

  void submit() {
    state = state.copyWith(submitted: true);
  }
}

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
        OnboardingViewModel.new);

final collegeOptionsProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(collegeRepositoryProvider);
  final result = await repo.getColleges();
  return result.when(success: (data) => data, failure: (_) => const []);
});

final cityOptionsProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(cityRepositoryProvider);
  final result = await repo.getCities();
  return result.when(success: (data) => data, failure: (_) => const []);
});

final subjectOptionsProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(subjectRepositoryProvider);
  final result = await repo.getSubjects();
  return result.when(success: (data) => data, failure: (_) => const []);
});
