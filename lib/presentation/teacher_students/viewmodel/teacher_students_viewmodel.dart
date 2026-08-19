import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/usecases/get_students_for_teacher_usecase.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';

// Teacher Students tab (§10.2 "Students" — every student enrolled with this
// teacher, filterable by name). This feature owns no domain/data layer of
// its own beyond the `StudentRepository.getStudentsForTeacher` read method
// added alongside it — it's a read-only composition over `student_onboarding`
// (`Student`/`SubjectEnrollment`) and `catalog` (`Subject`, for enrollment
// display names), mirroring `student_progress_viewmodel.dart`.
//
// Note: matching `AuthViewModel`/`StudentProgressViewModel`, this project
// does not use `@riverpod` codegen — these are plain hand-written
// `Provider`/`FutureProvider`/`StateProvider`s. No mutable business state is
// written back here, only the ephemeral search-query filter, which still
// goes through Riverpod (not `setState`) per CLAUDE.md §2.

/// Every student enrolled with the current teacher (i.e. has a
/// `SubjectEnrollment` where `teacherId == currentTeacher.id`). Empty (not
/// an error) when the teacher has no students yet — the view renders
/// `EmptyStateView` in that case, per §10.1.
final teacherStudentsProvider = FutureProvider<List<Student>>((ref) async {
  final teacher = ref.watch(currentTeacherProvider);
  if (teacher == null) {
    // Edge case only — router redirect guarantees a resolved teacher profile
    // before the teacher shell is reachable.
    return const <Student>[];
  }

  final result = await sl<GetStudentsForTeacherUseCase>()(teacher.id);
  return result.when(
    success: (students) => students,
    failure: (failure) => throw failure,
  );
});

/// All catalog subjects (across every distinct `boardClassId` the fetched
/// students belong to) keyed by id, so student rows can show human-readable
/// subject names instead of raw `subjectId`s (§10.1 — cards must show
/// scannable info, not raw ids). Mirrors `progressTestsByIdProvider` in
/// `student_progress_viewmodel.dart`, except `GetSubjectsUseCase` is scoped
/// per `boardClassId` (§9.2 — a subject can't leak across board/classes), so
/// this fetches once per distinct board/class present among the students.
final teacherStudentsSubjectsByIdProvider = FutureProvider<Map<String, Subject>>((
  ref,
) async {
  final students = await ref.watch(teacherStudentsProvider.future);
  final boardClassIds = students
      .map((s) => s.boardClassId)
      .whereType<String>()
      .toSet();

  final getSubjects = ref.read(getSubjectsUseCaseProvider);
  final subjectsById = <String, Subject>{};
  for (final boardClassId in boardClassIds) {
    final result = await getSubjects(boardClassId);
    result.when(
      success: (subjects) => subjectsById.addEntries(
        subjects.map((subject) => MapEntry(subject.id, subject)),
      ),
      failure: (failure) => throw failure,
    );
  }
  return subjectsById;
});

/// Ephemeral client-side search text for the Students tab's name filter — no
/// backend search endpoint for Phase 1. Still routed through a hand-written
/// `Notifier` (not `setState`) since it drives what the list view renders,
/// per CLAUDE.md §2 ("setState is strictly forbidden for business or shared
/// state"). `flutter_riverpod ^3.4.2` dropped the legacy `StateProvider`
/// (see `flutter_riverpod.dart`'s export list), so this mirrors
/// `SplashViewModel` (`presentation/splash/viewmodel/splash_viewmodel.dart`)
/// — the simplest `Notifier<T>` precedent in this codebase — rather than
/// reaching for a removed API.
class TeacherStudentsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

final teacherStudentsSearchQueryProvider =
    NotifierProvider<TeacherStudentsSearchQueryNotifier, String>(
      TeacherStudentsSearchQueryNotifier.new,
    );

/// Case-insensitive substring match of [query] against [student]'s name.
bool teacherStudentMatchesQuery(Student student, String query) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) return true;
  return student.name.toLowerCase().contains(trimmed);
}

/// Returns the list of subject names that [student] is enrolled in with [teacher].
List<String> teacherStudentSubjectsFor(
  Student student,
  Teacher teacher,
  Map<String, Subject> subjectsById,
) {
  final enrollments = student.subjectEnrollments ?? const [];
  return enrollments
      .where((e) => e.teacherId == teacher.id)
      .map((e) => subjectsById[e.subjectId]?.name ?? e.subjectId)
      .toList();
}
