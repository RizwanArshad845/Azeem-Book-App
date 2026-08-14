import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/onboarding/entities/class_level.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default('') String phoneNumber,
    @Default(false) bool otpVerified,
    @Default(0) int otpAttempts,
    @Default(false) bool otpLocked,
    @Default('') String name,
    @Default('') String city,
    @Default('') String college,
    ClassLevel? classLevel,
    @Default('') String classCode,
    @Default(3) int subjectCount,
    @Default(<String>[]) List<String> subjects,
    @Default(false) bool submitted,
  }) = _OnboardingState;

  const OnboardingState._();

  bool get isPhoneStepComplete => phoneNumber.trim().length == 10;

  bool get isPersonalInfoComplete =>
      name.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      college.trim().isNotEmpty &&
      classLevel != null;

  bool get isSubjectSelectionComplete =>
      subjects.isNotEmpty &&
      subjects.every((s) => s.trim().isNotEmpty) &&
      subjects.toSet().length == subjects.length;

  bool get isOnboardingComplete =>
      otpVerified &&
      isPersonalInfoComplete &&
      isSubjectSelectionComplete &&
      submitted;
}
