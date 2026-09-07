import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../../domain/teacher_onboarding/usecases/get_teacher_by_phone_usecase.dart';
import '../../../domain/teacher_onboarding/usecases/sign_up_teacher_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

/// Note: this project's `pubspec.yaml` does not include `riverpod_generator`
/// / `riverpod_annotation` (only `flutter_riverpod`), so — consistent with
/// `AuthViewModel`/`SplashViewModel` — this is a hand-written `AsyncNotifier`
/// with a manually declared provider rather than `@riverpod` codegen.

/// Where a Teacher currently stands in onboarding, derived from `Teacher`
/// fields once a record exists. Consumed by the (separate, later-batch)
/// router redirect logic to decide signup-form vs. pending-approval-screen
/// vs. shell-entry:
/// - `AsyncValue.loading` -> still checking phone number, show a spinner.
/// - `AsyncValue.data(null)` -> no Teacher record yet, show the signup form.
/// - `AsyncValue.data(teacher)` -> inspect [teacherOnboardingStageOf].
enum TeacherOnboardingStage {
  /// Salesman-seeded record matched this phone number — signup was skipped
  /// entirely and the teacher is already approved.
  seededPassThrough,

  /// Self-signup submitted but not yet approved by Admin.
  pendingApproval,

  /// Self-signup and Admin-approved — functions identically to
  /// [seededPassThrough] from here on.
  complete,
}

/// Classifies an existing [Teacher] record into a [TeacherOnboardingStage].
TeacherOnboardingStage teacherOnboardingStageOf(Teacher teacher) {
  if (teacher.onboardingSource == TeacherOnboardingSource.salesmanSeeded) {
    return TeacherOnboardingStage.seededPassThrough;
  }
  return teacher.approvalStatus == TeacherApprovalStatus.approved
      ? TeacherOnboardingStage.complete
      : TeacherOnboardingStage.pendingApproval;
}

/// Drives the teacher onboarding flow (§9.1): on `build()`, checks whether a
/// Teacher record already exists for the logged-in phone number (salesman
/// seeded) or whether the self-signup form needs to be shown. Exposes
/// [submitSignUp] for the form's single submit action.
class TeacherOnboardingViewModel extends AsyncNotifier<Teacher?> {
  @override
  Future<Teacher?> build() async {
    final session = ref.watch(currentUserProvider);
    if (session == null) return null;

    var result = await sl<GetTeacherByPhoneUseCase>()(session.phoneNumber);
    if (!result.isSuccess) {
      // Absorb a single transient blip (e.g. a fresh login racing a
      // still-settling connection) with one retry before giving up — see
      // the matching comment on `StudentOnboardingViewModel.build()`.
      await Future.delayed(const Duration(milliseconds: 800));
      result = await sl<GetTeacherByPhoneUseCase>()(session.phoneNumber);
    }
    return result.when(
      success: (teacher) => teacher,
      failure: (failure) => throw failure,
    );
  }

  /// Submits the self-signup form. Only meaningful when [build] resolved to
  /// `null` (no salesman-seeded record matched this phone number). Builds
  /// the new `Teacher` from the current `AuthSession` (`id`/`phoneNumber`/
  /// `role`) plus the form's own fields, and always creates it as
  /// `selfSignup` per §9.1 — `approvalStatus` is `pendingAdminApproval` in
  /// real-API mode, but auto-`approved` in mock mode (see inline comment
  /// below) since there's no in-app way to approve it otherwise. Deliberately
  /// does not navigate — callers should just let this `AsyncValue` resolve;
  /// router redirect logic lands in a later batch.
  Future<bool> submitSignUp({
    required String name,
    required String campusId,
    required List<String> subjectIds,
    List<String>? classIds,
    int? declaredStudentCount,
  }) async {
    final session = ref.read(currentUserProvider);
    if (session == null) {
      state = AsyncError<Teacher?>(
        const ValidationFailure('No active session to sign up with.'),
        StackTrace.current,
      );
      return false;
    }

    final now = DateTime.now();
    final teacher = Teacher(
      id: session.userId!,
      name: name,
      phoneNumber: session.phoneNumber,
      role: session.role,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
      campusId: campusId,
      subjectIds: subjectIds,
      classIds: classIds,
      declaredStudentCount: declaredStudentCount,
      salesmanId: null,
      onboardingSource: TeacherOnboardingSource.selfSignup,
      // Self-signup teachers always start pending — only the (separate,
      // out-of-scope) Admin App can flip this to `approved`.
      approvalStatus: TeacherApprovalStatus.pendingAdminApproval,
      actualEarnings: 0,
      projectedEarnings: null,
    );

    state = const AsyncLoading<Teacher?>();
    final result = await sl<SignUpTeacherUseCase>()(teacher);
    return result.when(
      success: (created) {
        state = AsyncData<Teacher?>(created);
        return true;
      },
      failure: (failure) {
        state = AsyncError<Teacher?>(failure, StackTrace.current);
        return false;
      },
    );
  }

  /// Re-runs the phone lookup (e.g. a "check status" tap on the pending
  /// approval screen).
  void refresh() => ref.invalidateSelf();

  /// Lets other features (`teacher-profile`'s "Edit profile" action) push
  /// an externally-updated [Teacher] back into this shared provider after a
  /// successful write, without re-running [build].
  void setTeacher(Teacher teacher) {
    state = AsyncData<Teacher?>(teacher);
  }
}

final teacherOnboardingViewModelProvider =
    AsyncNotifierProvider<TeacherOnboardingViewModel, Teacher?>(
      TeacherOnboardingViewModel.new,
    );
