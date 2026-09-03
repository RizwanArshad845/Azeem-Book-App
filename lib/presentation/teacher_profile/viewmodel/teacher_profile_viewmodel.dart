import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/auth/usecases/request_phone_change_otp_usecase.dart';
import '../../../domain/auth/usecases/verify_phone_change_otp_usecase.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../../domain/teacher_onboarding/usecases/delete_teacher_account_usecase.dart';
import '../../../domain/teacher_onboarding/usecases/update_teacher_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';

/// Thin write-action `AsyncNotifier` for the `teacher-profile` feature
/// (§10.2 Profile "Edit profile" / "delete account" — the latter applied
/// here for parity with `student-profile` per §9.1's narrative text; see
/// the §10.2/§9.1 scope-TBD note on the teacher Profile row). Does not hold
/// the teacher itself — `teacherOnboardingViewModelProvider` remains the
/// single source of truth for the current `Teacher`; this notifier only
/// tracks the in-flight/error state of the two mutation actions below and,
/// on success, pushes the result back into that shared provider.
///
/// Note: this project has no `riverpod_generator` dependency (only
/// `flutter_riverpod`), so — consistent with `TeacherOnboardingViewModel`/
/// `StudentProfileViewModel` — this is a hand-written `AsyncNotifier` with a
/// manually declared provider, not `@riverpod` codegen. Riverpod 3.x has no
/// `AsyncValue.valueOrNull` — `.value` is used directly.
class TeacherProfileViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Requests a real OTP be sent to [newPhone] (`backend.md` §4.8). Returns
  /// `true` on success so the view can open the verification sheet.
  Future<bool> requestPhoneChangeOtp(String currentPhone, String newPhone) async {
    state = const AsyncLoading<void>();
    final result = await sl<RequestPhoneChangeOtpUseCase>()(
      currentPhone,
      newPhone,
    );
    if (result is ResultFailure<void>) {
      state = AsyncError<void>(result.failure, StackTrace.current);
      return false;
    }
    state = const AsyncData<void>(null);
    return true;
  }

  /// Verifies the OTP sent to [newPhone] against the real backend
  /// (`backend.md` §4.8). Returns `true` on success.
  Future<bool> verifyPhoneChangeOtp(String newPhone, String otp) async {
    state = const AsyncLoading<void>();
    final result = await sl<VerifyPhoneChangeOtpUseCase>()(newPhone, otp);
    if (result is ResultFailure<void>) {
      state = AsyncError<void>(result.failure, StackTrace.current);
      return false;
    }
    state = const AsyncData<void>(null);
    return true;
  }

  /// Saves a name/phone edit. Returns `true` on success so the view can show
  /// a confirmation snackbar without re-deriving it from `state`.
  Future<bool> updateProfile({
    required String name,
    required String phoneNumber,
  }) async {
    final current = ref.read(teacherOnboardingViewModelProvider).value;
    if (current == null) {
      state = AsyncError<void>(
        const ValidationFailure('No profile loaded to update.'),
        StackTrace.current,
      );
      return false;
    }

    final updated = current.copyWith(name: name, phoneNumber: phoneNumber);

    state = const AsyncLoading<void>();
    final result = await sl<UpdateTeacherUseCase>()(updated);
    if (result is ResultFailure<Teacher>) {
      state = AsyncError<void>(result.failure, StackTrace.current);
      return false;
    }

    final saved = (result as Success<Teacher>).data;
    ref.read(teacherOnboardingViewModelProvider.notifier).setTeacher(saved);
    state = const AsyncData<void>(null);
    return true;
  }

  /// Soft-deletes the current teacher's account, then logs out via the same
  /// path `AuthViewModel` already exposes — there's no session left to keep,
  /// and the router's `currentUserProvider`-keyed redirect (see
  /// `lib/core/router/app_router.dart`) sends the teacher back to auth on
  /// its own once `authViewModelProvider` clears. Returns `true` on success.
  Future<bool> deleteAccount() async {
    final teacherId =
        ref.read(teacherOnboardingViewModelProvider).value?.id ??
        ref.read(currentUserProvider)?.userId;
    if (teacherId == null) {
      state = AsyncError<void>(
        const ValidationFailure('No account to delete.'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading<void>();
    final result = await sl<DeleteTeacherAccountUseCase>()(teacherId);
    if (result is ResultFailure<void>) {
      state = AsyncError<void>(result.failure, StackTrace.current);
      return false;
    }

    await ref.read(authViewModelProvider.notifier).logout();
    state = const AsyncData<void>(null);
    return true;
  }
}

final teacherProfileViewModelProvider =
    AsyncNotifierProvider<TeacherProfileViewModel, void>(
      TeacherProfileViewModel.new,
    );
