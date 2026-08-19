import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/get_student_test_attempts_usecase.dart';
import 'teacher_students_viewmodel.dart';

// Per-student progress detail, pushed from the Students tab list
// (`AppRoutes.teacherStudentProgressDetail`, now parameterized by
// `:studentId`). Reuses `GetStudentTestAttemptsUseCase`
// (`domain/test_taking/usecases/get_student_test_attempts_usecase.dart`) —
// the exact same use case `student-progress` already built — rather than
// reimplementing attempt-fetching, per this unit's brief.

/// Resolves [studentId] against the already-fetched `teacherStudentsProvider`
/// list rather than adding a new `StudentRepository.getById` read path — the
/// detail screen is only ever reachable by tapping a row in that list, so
/// the student is guaranteed to already be in it. Resolves to `null` only in
/// the edge case of a stale/direct deep link to an id outside this teacher's
/// roster.
final teacherViewedStudentProvider = FutureProvider.family<Student?, String>((
  ref,
  studentId,
) async {
  final students = await ref.watch(teacherStudentsProvider.future);
  for (final student in students) {
    if (student.id == studentId) return student;
  }
  return null;
});

/// All test attempts submitted by [studentId], newest first (same use case
/// and ordering `student-progress` already relies on).
final teacherStudentAttemptsProvider =
    FutureProvider.family<List<TestAttempt>, String>((ref, studentId) async {
      final result = await sl<GetStudentTestAttemptsUseCase>()(studentId);
      return result.when(
        success: (attempts) => attempts,
        failure: (failure) => throw failure,
      );
    });

/// Simple average of `scorePercent` across [attempts]; `0` when empty (the
/// view never calls this for an empty list — it renders `EmptyStateView`
/// instead — but a safe default avoids a division-by-zero footgun for any
/// future caller).
double averageScorePercent(List<TestAttempt> attempts) {
  if (attempts.isEmpty) return 0;
  final total = attempts.fold<double>(0, (sum, a) => sum + a.scorePercent);
  return total / attempts.length;
}
