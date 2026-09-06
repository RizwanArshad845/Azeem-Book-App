import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/usecases/delete_student_account_usecase.dart';
import '../../../domain/student_onboarding/usecases/update_student_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';

/// Thin write-action `AsyncNotifier` for the `student-profile` feature
/// (§10.2 Profile "Edit profile" / "delete account"). Does not hold the
/// student itself — `studentOnboardingViewModelProvider` remains the single
/// source of truth for the current `Student`; this notifier only tracks the
/// in-flight/error state of the two mutation actions below and, on success,
/// pushes the result back into that shared provider.
///
/// Note: this project has no `riverpod_generator` dependency (only
/// `flutter_riverpod`), so — consistent with `StudentOnboardingViewModel`/
/// `LiveTestRegistrationViewModel` — this is a hand-written `AsyncNotifier`
/// with a manually declared provider, not `@riverpod` codegen. Riverpod 3.x
/// has no `AsyncValue.valueOrNull` — `.value` is used directly.
class StudentProfileViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Saves a name/phone edit. Returns `true` on success so the view can show
  /// a confirmation snackbar without re-deriving it from `state`.
  Future<bool> updateProfile({
    required String name,
    required String phoneNumber,
  }) async {
    final current = ref.read(studentOnboardingViewModelProvider).value;
    if (current == null) {
      state = AsyncError<void>(
        const ValidationFailure('No profile loaded to update.'),
        StackTrace.current,
      );
      return false;
    }

    final updated = current.copyWith(name: name, phoneNumber: phoneNumber);

    state = const AsyncLoading<void>();
    final result = await sl<UpdateStudentUseCase>()(updated);
    if (result is ResultFailure<Student>) {
      state = AsyncError<void>(result.failure, StackTrace.current);
      return false;
    }

    final saved = (result as Success<Student>).data;
    ref.read(studentOnboardingViewModelProvider.notifier).setStudent(
      saved.copyWith(
        subjectEnrollments:
            saved.subjectEnrollments ?? current.subjectEnrollments,
        boardClassId: saved.boardClassId ?? current.boardClassId,
        cartId: saved.cartId ?? current.cartId,
      ),
    );
    state = const AsyncData<void>(null);
    return true;
  }

  /// Soft-deletes the current student's account, then logs out via the same
  /// path `AuthViewModel` already exposes — there's no session left to keep,
  /// and the router's `currentUserProvider`-keyed redirect (see
  /// `lib/core/router/app_router.dart`) sends the student back to auth on
  /// its own once `authViewModelProvider` clears. Returns `true` on success.
  Future<bool> deleteAccount() async {
    final studentId =
        ref.read(studentOnboardingViewModelProvider).value?.id ??
        ref.read(currentUserProvider)?.userId;
    if (studentId == null) {
      state = AsyncError<void>(
        const ValidationFailure('No account to delete.'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading<void>();
    final result = await sl<DeleteStudentAccountUseCase>()(studentId);
    if (result is ResultFailure<void>) {
      state = AsyncError<void>(result.failure, StackTrace.current);
      return false;
    }

    await ref.read(authViewModelProvider.notifier).logout();
    state = const AsyncData<void>(null);
    return true;
  }
}

final studentProfileViewModelProvider =
    AsyncNotifierProvider<StudentProfileViewModel, void>(
      StudentProfileViewModel.new,
    );
