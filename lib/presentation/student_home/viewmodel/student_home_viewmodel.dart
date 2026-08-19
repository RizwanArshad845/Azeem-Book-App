import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';

// Student Home tab (§10.2 "Selected subjects grid, live-test banner,
// subject -> chapter -> test drill-down"). This feature owns no domain/data
// layer of its own — it is a read-only composition over the existing
// catalog use cases (`Subject`/`Chapter`/`Test`) and the `Student` profile
// already resolved by `studentOnboardingViewModelProvider` (§9.1/§9.2).
//
// Note: matching `AuthViewModel`/`StudentOnboardingViewModel`, this project
// does not use `@riverpod` codegen (no `riverpod_generator` dependency) —
// these are plain hand-written `Provider`/`FutureProvider`s.

/// Read-only accessor for the current student's profile, mirroring how
/// `currentUserProvider` derives from `authViewModelProvider` in
/// `presentation/auth/viewmodel/auth_viewmodel.dart`. There is no separate
/// "get student by id" read path yet (Phase-1 scope limit, acknowledged) —
/// `studentOnboardingViewModelProvider`'s resolved value IS the current
/// student's profile for the remainder of the app session.
final currentStudentProvider = Provider<Student?>((ref) {
  return ref.watch(
    studentOnboardingViewModelProvider.select((async) => async.value),
  );
});

/// Subjects the current student is enrolled in, scoped to their
/// `boardClassId` and filtered down to the `subjectId`s present in their
/// `subjectEnrollments` (§9.1 Student / SubjectEnrollment). Empty (not an
/// error) when the student has no board/class or no enrollments yet.
final enrolledSubjectsProvider = FutureProvider<List<Subject>>((ref) async {
  final student = ref.watch(currentStudentProvider);
  final boardClassId = student?.boardClassId;
  if (student == null || boardClassId == null) return const <Subject>[];

  final enrolledSubjectIds = (student.subjectEnrollments ?? const [])
      .map((enrollment) => enrollment.subjectId)
      .toSet();
  if (enrolledSubjectIds.isEmpty) return const <Subject>[];

  final result = await ref.read(getSubjectsUseCaseProvider)(boardClassId);
  return result.when(
    success: (subjects) =>
        subjects.where((s) => enrolledSubjectIds.contains(s.id)).toList(),
    failure: (failure) => throw failure,
  );
});

/// Looks up a single enrolled [Subject] by id from [enrolledSubjectsProvider]
/// — used by `ChapterListView`'s bundle-purchase header, which only knows
/// `subjectId` (the router only passes that path param, see
/// `app_router.dart`'s `subject/:subjectId/chapters` route) but needs the
/// full `Subject` entity to call `StudentCartViewModel.addSubjectBundle`.
/// `null` (not an error) if the id isn't among the student's enrolled
/// subjects.
final subjectByIdProvider = FutureProvider.family<Subject?, String>(
  (ref, subjectId) async {
    final subjects = await ref.watch(enrolledSubjectsProvider.future);
    for (final subject in subjects) {
      if (subject.id == subjectId) return subject;
    }
    return null;
  },
);

/// Chapters for a tapped subject, ordered by `Chapter.order` (§9.1 —
/// "first chapter free" and the chapter drill-down both depend on order).
final chaptersForSubjectProvider = FutureProvider.family<List<Chapter>, String>(
  (ref, subjectId) async {
    final result = await ref.read(getChaptersUseCaseProvider)(subjectId);
    return result.when(
      success: (chapters) {
        final sorted = [...chapters]
          ..sort((a, b) => a.order.compareTo(b.order));
        return sorted;
      },
      failure: (failure) => throw failure,
    );
  },
);

/// Tests for a tapped chapter.
final testsForChapterProvider = FutureProvider.family<List<Test>, String>(
  (ref, chapterId) async {
    final result = await ref.read(getTestsUseCaseProvider)(
      chapterId: chapterId,
    );
    return result.when(
      success: (tests) => tests,
      failure: (failure) => throw failure,
    );
  },
);

/// Sparse list of live tests (`Test.isLive == true`) scoped to the current
/// student's enrolled subjects, sorted by `liveDate` ascending (soonest
/// first; tests missing a `liveDate` sort last). Admin schedules these only
/// occasionally, so this is expected to be empty most of the time — the view
/// renders no banner at all in that case, per §10.1 "not a broken empty
/// banner."
final liveTestsProvider = FutureProvider<List<Test>>((ref) async {
  final subjects = await ref.watch(enrolledSubjectsProvider.future);
  if (subjects.isEmpty) return const <Test>[];

  final getTests = ref.read(getTestsUseCaseProvider);
  final liveTests = <Test>[];
  for (final subject in subjects) {
    final result = await getTests(subjectId: subject.id);
    result.when(
      success: (tests) => liveTests.addAll(tests.where((t) => t.isLive)),
      failure: (failure) => throw failure,
    );
  }

  liveTests.sort((a, b) {
    final aDate = a.liveDate;
    final bDate = b.liveDate;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return aDate.compareTo(bDate);
  });
  return liveTests;
});
