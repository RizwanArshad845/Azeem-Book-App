import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/get_student_test_attempts_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

// Student Progress tab (§10.2 "Attempted tests list, overall progress,
// per-test report (pie chart)"). This feature owns no domain/data layer of
// its own — it is a read-only composition over the existing `test_taking`
// (`TestAttempt`) and `catalog` (`Test`/`Question`) layers, mirroring how
// `student_home_viewmodel.dart` composes over `catalog` alone.
//
// Note: matching `AuthViewModel`/`StudentHomeViewModel`, this project does
// not use `@riverpod` codegen (no `riverpod_generator` dependency) — these
// are plain hand-written `Provider`/`FutureProvider`s. No mutable state is
// needed here (nothing on this screen is ever written back), so there is no
// `AsyncNotifier` class, same as `student_home_viewmodel.dart`.

/// All of the current student's submitted attempts, newest first (the
/// dummy/remote datasources already return them sorted). Empty (not an
/// error) when the student hasn't attempted anything yet — the view renders
/// `EmptyStateView` in that case, per §10.1.
final studentTestAttemptsProvider = FutureProvider<List<TestAttempt>>((
  ref,
) async {
  final session = ref.watch(currentUserProvider);
  if (session == null) {
    // Edge case only — router redirect guarantees a resolved session before
    // the student shell is reachable (mirrors `StudentCartViewModel.build()`).
    return const <TestAttempt>[];
  }

  final result = await sl<GetStudentTestAttemptsUseCase>()(session.userId);
  return result.when(
    success: (attempts) => attempts,
    failure: (failure) => throw failure,
  );
});

/// All catalog tests keyed by id, so attempt cards can show a human-readable
/// `Test.title` instead of a raw `testId` (§10.1 — cards must show scannable
/// info, not raw ids). Mirrors `cartTestsByIdProvider` in
/// `student_cart_viewmodel.dart`.
final progressTestsByIdProvider = FutureProvider<Map<String, Test>>((
  ref,
) async {
  final result = await ref.read(getTestsUseCaseProvider)();
  return result.when(
    success: (tests) => {for (final test in tests) test.id: test},
    failure: (failure) => throw failure,
  );
});

/// Plain aggregate backing the Progress tab's pie chart — NOT a
/// `project_spec.md` §9.2 entity (never persisted), so a hand-written class
/// is enough, mirroring `WeakStrongChapters` in
/// `compute_weak_strong_chapters.dart`.
class ChapterProgressSummary {
  const ChapterProgressSummary({
    required this.weakCount,
    required this.strongCount,
    required this.averageCount,
  });

  static const empty = ChapterProgressSummary(
    weakCount: 0,
    strongCount: 0,
    averageCount: 0,
  );

  final int weakCount;
  final int strongCount;
  final int averageCount;

  int get total => weakCount + strongCount + averageCount;
}

/// Aggregate weak/strong/average chapter counts across every attempt.
///
/// Reuses each `TestAttempt`'s already-computed `weakChapterIds`/
/// `strongChapterIds` (produced once at submission time by
/// `compute_weak_strong_chapters.dart`) rather than re-deriving the
/// weak/strong threshold logic here — this provider only aggregates. Chapters
/// that don't land in either bucket are "average"; the full set of chapters
/// the student has been tested on at all is derived from `Question.chapterId`
/// across the distinct tests they've attempted (via the existing
/// `GetQuestionsUseCase`), since `TestAttempt` itself doesn't record that.
final chapterProgressSummaryProvider = FutureProvider<ChapterProgressSummary>((
  ref,
) async {
  final attempts = await ref.watch(studentTestAttemptsProvider.future);
  if (attempts.isEmpty) return ChapterProgressSummary.empty;

  final weakChapterIds = <String>{};
  final strongChapterIds = <String>{};
  for (final attempt in attempts) {
    weakChapterIds.addAll(attempt.weakChapterIds ?? const []);
    strongChapterIds.addAll(attempt.strongChapterIds ?? const []);
  }

  final getQuestions = ref.read(getQuestionsUseCaseProvider);
  final allChapterIds = <String>{};
  final uniqueTestIds = attempts.map((a) => a.testId).toSet();
  for (final testId in uniqueTestIds) {
    final result = await getQuestions(testId);
    result.when(
      success: (questions) =>
          allChapterIds.addAll(questions.map((q) => q.chapterId)),
      failure: (failure) => throw failure,
    );
  }

  final averageChapterIds = allChapterIds
      .difference(weakChapterIds)
      .difference(strongChapterIds);

  return ChapterProgressSummary(
    weakCount: weakChapterIds.length,
    strongCount: strongChapterIds.length,
    averageCount: averageChapterIds.length,
  );
});
