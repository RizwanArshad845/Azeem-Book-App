import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';

// Teacher Overview tab (§10.2 "Students onboarded, actual + projected
// earnings summary"). This feature owns no domain/data layer of its own — it
// is a read-only composition over the `Teacher` profile already resolved by
// `teacherOnboardingViewModelProvider` (§9.1/§9.2), mirroring how
// `currentStudentProvider` derives from `studentOnboardingViewModelProvider`
// in `presentation/student_home/viewmodel/student_home_viewmodel.dart`.
//
// Note: matching `AuthViewModel`/`TeacherOnboardingViewModel`, this project
// does not use `@riverpod` codegen (no `riverpod_generator` dependency) —
// this is a plain hand-written `Provider`.

/// Read-only accessor for the current teacher's profile, mirroring
/// `currentStudentProvider` (student_home) and `currentUserProvider` (auth).
/// There is no separate "get teacher by id" read path yet (Phase-1 scope
/// limit, acknowledged) — `teacherOnboardingViewModelProvider`'s resolved
/// value IS the current teacher's profile for the remainder of the app
/// session.
final currentTeacherProvider = Provider<Teacher?>((ref) {
  return ref.watch(
    teacherOnboardingViewModelProvider.select((async) => async.value),
  );
});
