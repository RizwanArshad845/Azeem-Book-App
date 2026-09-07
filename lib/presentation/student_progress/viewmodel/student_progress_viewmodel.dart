import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/get_student_test_attempts_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

// The Overall-vs-Per-Subject toggle and per-subject grouping below are new
// logic (per CLAUDE.md's Progress Screen requirement), but they compose
// over the same `studentTestAttemptsProvider`/`progressTestsByIdProvider`
// already defined above rather than re-fetching attempts a second way.

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

  final result = await sl<GetStudentTestAttemptsUseCase>()(session.userId!);
  return result.when(
    success: (attempts) => attempts,
    failure: (failure) => throw failure,
  );
});

/// True once the student has submitted at least one test attempt (any
/// test). Drives the pricing-visibility rule: price stays hidden on
/// discovery screens (Home subject cards, Chapters bundle header) until
/// this flips true, then it's shown from the result screen onward.
final hasCompletedAnyTestAttemptProvider = Provider<bool>((ref) {
  final attempts = ref.watch(studentTestAttemptsProvider).value;
  return attempts != null && attempts.isNotEmpty;
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
  // One lookup per distinct test, fired in parallel — see
  // `perSubjectProgressProvider`'s `getSubjects` batch for why.
  final questionResults = await Future.wait(
    uniqueTestIds.map(getQuestions.call),
  );
  for (final result in questionResults) {
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

/// Which slice of the Progress tab is on screen — CLAUDE.md's "Progress
/// Screen: ... filter toggles for Overall Cumulative Progress vs Per-Subject
/// Progress". Purely a UI display toggle (no persistence, nothing written
/// back), but still routed through Riverpod rather than `setState` per
/// CLAUDE.md §2. `flutter_riverpod ^3.4.2` dropped the legacy
/// `StateProvider` (see `flutter_riverpod.dart`'s export list), so this
/// mirrors `TeacherStudentsSearchQueryNotifier`
/// (`teacher_students_viewmodel.dart`) — the established hand-written
/// `Notifier<T>` pattern for this kind of ephemeral display state.
enum ProgressViewMode { overall, perSubject }

class ProgressViewModeNotifier extends Notifier<ProgressViewMode> {
  @override
  ProgressViewMode build() => ProgressViewMode.overall;

  void setMode(ProgressViewMode mode) => state = mode;
}

final progressViewModeProvider =
    NotifierProvider<ProgressViewModeNotifier, ProgressViewMode>(
      ProgressViewModeNotifier.new,
    );

/// Plain view-model-local aggregate for one subject's worth of progress —
/// NOT a `project_spec.md` §9.2 entity (there is no persisted "per-subject
/// progress" row anywhere in the schema; this is derived purely from
/// existing `TestAttempt`s at read time), so a hand-written class is enough
/// here too, same reasoning as `ChapterProgressSummary` above.
class SubjectProgressSummary {
  const SubjectProgressSummary({
    required this.subjectId,
    required this.subjectName,
    required this.attemptCount,
    required this.averageScorePercent,
    required this.weakChapterCount,
    required this.strongChapterCount,
  });

  final String subjectId;
  final String subjectName;
  final int attemptCount;
  final double averageScorePercent;
  final int weakChapterCount;
  final int strongChapterCount;
}

/// Groups the student's attempts by subject (§10.2 Progress tab's
/// Per-Subject filter). There is no `TestAttempt.subjectId` field in the
/// schema — each attempt only carries a `testId` — so subjects are resolved
/// by joining through `Test.subjectId` (via [progressTestsByIdProvider],
/// already loaded for the attempts list) and then through
/// [GetSubjectsUseCase] (scoped per `boardClassId`, per `CatalogRepository`)
/// to recover a human-readable `Subject.name` for the group label. Mirrors
/// [chapterProgressSummaryProvider]'s approach of aggregating each attempt's
/// already-computed `weakChapterIds`/`strongChapterIds` rather than
/// re-deriving the weak/strong threshold logic here.
final perSubjectProgressProvider =
    FutureProvider<List<SubjectProgressSummary>>((ref) async {
      // See `filteredAttemptsProvider` for why these are read eagerly
      // before either is awaited (lets the independent tests fetch run
      // concurrently with the attempts fetch).
      final attemptsFuture = ref.watch(studentTestAttemptsProvider.future);
      final testsByIdFuture = ref.watch(progressTestsByIdProvider.future);

      final attempts = await attemptsFuture;
      if (attempts.isEmpty) return const <SubjectProgressSummary>[];

      final testsById = await testsByIdFuture;

      final attemptsBySubject = <String, List<TestAttempt>>{};
      final boardClassIdBySubject = <String, String>{};
      for (final attempt in attempts) {
        final test = testsById[attempt.testId];
        // A test that no longer resolves (deleted from the catalog after
        // the attempt was submitted) can't be grouped by subject — skip it
        // rather than crash; it still counts toward the Overall view via
        // `chapterProgressSummaryProvider`, which doesn't need the join.
        if (test == null) continue;
        attemptsBySubject.putIfAbsent(test.subjectId, () => []).add(attempt);
        boardClassIdBySubject[test.subjectId] = test.boardClassId;
      }

      final getSubjects = ref.read(getSubjectsUseCaseProvider);
      final subjectNameById = <String, String>{};
      final distinctBoardClassIds = boardClassIdBySubject.values.toSet();
      // One lookup per distinct board class, fired in parallel rather than
      // sequentially — `CatalogRepositoryImpl.getSubjects` already caches
      // by `boardClassId` in memory, so repeat calls elsewhere are cheap,
      // but a *cold* Progress load with several distinct board classes was
      // paying for each round-trip one after another.
      final subjectResults = await Future.wait(
        distinctBoardClassIds.map(getSubjects.call),
      );
      for (final result in subjectResults) {
        result.when(
          success: (subjects) {
            for (final subject in subjects) {
              subjectNameById[subject.id] = subject.name;
            }
          },
          failure: (failure) => throw failure,
        );
      }

      final summaries = <SubjectProgressSummary>[
        for (final entry in attemptsBySubject.entries)
          _summarizeSubject(
            subjectId: entry.key,
            subjectName: subjectNameById[entry.key] ?? entry.key,
            subjectAttempts: entry.value,
          ),
      ]..sort((a, b) => a.subjectName.compareTo(b.subjectName));

      return summaries;
    });

SubjectProgressSummary _summarizeSubject({
  required String subjectId,
  required String subjectName,
  required List<TestAttempt> subjectAttempts,
}) {
  final weakChapterIds = <String>{};
  final strongChapterIds = <String>{};
  var scoreSum = 0.0;
  for (final attempt in subjectAttempts) {
    weakChapterIds.addAll(attempt.weakChapterIds ?? const []);
    strongChapterIds.addAll(attempt.strongChapterIds ?? const []);
    scoreSum += attempt.scorePercent ?? 0;
  }

  return SubjectProgressSummary(
    subjectId: subjectId,
    subjectName: subjectName,
    attemptCount: subjectAttempts.length,
    averageScorePercent: scoreSum / subjectAttempts.length,
    weakChapterCount: weakChapterIds.length,
    strongChapterCount: strongChapterIds.length,
  );
}

/// Per-chapter aggregated progress for the chapter cards on the Progress screen.
class ChapterProgressData {
  const ChapterProgressData({
    required this.chapterId,
    required this.chapterTitle,
    required this.subjectId,
    required this.testId,
    required this.averagePercent,
    required this.attemptsCount,
    required this.attempts,
    this.latestAttempt,
  });

  final String chapterId;
  final String chapterTitle;
  final String subjectId;
  final String testId;
  final double averagePercent;
  final int attemptsCount;
  final List<TestAttempt> attempts;
  final TestAttempt? latestAttempt;
}

final chapterProgressListProvider =
    FutureProvider<List<ChapterProgressData>>((ref) async {
  return ref.watch(filteredChapterProgressListProvider.future);
});

/// Riverpod state for selected subject on Progress tab ('all' or subjectId).
class SelectedProgressSubjectNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setSubjectId(String subjectId) => state = subjectId;
}

final selectedProgressSubjectProvider =
    NotifierProvider<SelectedProgressSubjectNotifier, String>(
  SelectedProgressSubjectNotifier.new,
);

/// Riverpod state for selected attempt filter on Progress tab ('all', 'latest', '1', '2', etc.).
class SelectedProgressAttemptFilterNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setFilter(String filter) => state = filter;
}

final selectedProgressAttemptFilterProvider =
    NotifierProvider<SelectedProgressAttemptFilterNotifier, String>(
  SelectedProgressAttemptFilterNotifier.new,
);

/// Computes all available attempt filter options based on the student's actual attempt counts.
final availableAttemptFiltersProvider = FutureProvider<List<String>>((ref) async {
  final attempts = await ref.watch(studentTestAttemptsProvider.future);
  if (attempts.isEmpty) return const ['all'];

  final attemptsByTest = <String, int>{};
  for (final a in attempts) {
    attemptsByTest[a.testId] = (attemptsByTest[a.testId] ?? 0) + 1;
  }
  final maxAttempts = attemptsByTest.values.fold<int>(
    0,
    (max, count) => count > max ? count : max,
  );

  final filters = <String>['all'];
  if (maxAttempts > 1) {
    filters.add('latest');
  }
  for (var i = 1; i <= maxAttempts; i++) {
    filters.add('$i');
  }
  return filters;
});

/// Returns attempts filtered by both selected subject and selected attempt filter.
final filteredAttemptsProvider = FutureProvider<List<TestAttempt>>((ref) async {
  // Read both futures before awaiting either, so the (independent) tests
  // fetch starts concurrently with the attempts fetch instead of only
  // starting once attempts resolves — halves the network-bound latency on
  // a cold load versus sequential `await`s.
  final attemptsFuture = ref.watch(studentTestAttemptsProvider.future);
  final testsByIdFuture = ref.watch(progressTestsByIdProvider.future);

  final attempts = await attemptsFuture;
  if (attempts.isEmpty) return const <TestAttempt>[];

  final testsById = await testsByIdFuture;
  final selectedSubjectId = ref.watch(selectedProgressSubjectProvider);
  final selectedAttemptFilter = ref.watch(selectedProgressAttemptFilterProvider);

  // 1. Subject filter
  var subjectFiltered = attempts;
  if (selectedSubjectId != 'all') {
    subjectFiltered = attempts.where((a) {
      final test = testsById[a.testId];
      return test != null && test.subjectId == selectedSubjectId;
    }).toList();
  }

  if (selectedAttemptFilter == 'all' || subjectFiltered.isEmpty) {
    return subjectFiltered;
  }

  // 2. Attempt filter: group attempts by testId sorted chronologically (oldest to newest)
  final attemptsByTest = <String, List<TestAttempt>>{};
  for (final a in subjectFiltered) {
    attemptsByTest.putIfAbsent(a.testId, () => []).add(a);
  }
  for (final list in attemptsByTest.values) {
    list.sort((a, b) => a.attemptedAt.compareTo(b.attemptedAt));
  }

  final result = <TestAttempt>[];
  if (selectedAttemptFilter == 'latest') {
    for (final list in attemptsByTest.values) {
      if (list.isNotEmpty) result.add(list.last);
    }
  } else {
    final attemptNumber = int.tryParse(selectedAttemptFilter);
    if (attemptNumber != null && attemptNumber >= 1) {
      for (final list in attemptsByTest.values) {
        if (list.length >= attemptNumber) {
          result.add(list[attemptNumber - 1]);
        }
      }
    } else {
      return subjectFiltered;
    }
  }

  return result;
});

/// Aggregate overall mastery data (average score % and total tests attempted)
/// computed dynamically against active subject and attempt filters.
class OverallMasteryData {
  const OverallMasteryData({
    required this.masteryPercent,
    required this.testsAttempted,
  });

  final double masteryPercent;
  final int testsAttempted;
}

final filteredOverallMasteryProvider = FutureProvider<OverallMasteryData>((ref) async {
  final attempts = await ref.watch(filteredAttemptsProvider.future);
  if (attempts.isEmpty) {
    return const OverallMasteryData(masteryPercent: 0.0, testsAttempted: 0);
  }

  final averageScorePercent =
      attempts.map((a) => a.scorePercent ?? 0).reduce((a, b) => a + b) /
      attempts.length;

  return OverallMasteryData(
    masteryPercent: averageScorePercent,
    testsAttempted: attempts.length,
  );
});

/// Dynamic chapter breakdown cards computed dynamically from active filters.
final filteredChapterProgressListProvider =
    FutureProvider<List<ChapterProgressData>>((ref) async {
  final filteredAttempts = await ref.watch(filteredAttemptsProvider.future);
  if (filteredAttempts.isEmpty) return const <ChapterProgressData>[];

  final testsById = await ref.watch(progressTestsByIdProvider.future);
  final getChapters = ref.read(getChaptersUseCaseProvider);

  // Group attempts by testId
  final attemptsByTest = <String, List<TestAttempt>>{};
  for (final attempt in filteredAttempts) {
    attemptsByTest.putIfAbsent(attempt.testId, () => []).add(attempt);
  }

  // Resolve every distinct subject's chapters up front, in parallel,
  // instead of one-at-a-time inside the loop below — same reasoning as
  // `perSubjectProgressProvider`'s `getSubjects` batch: this only pays a
  // real network cost per subject not already in `CatalogRepositoryImpl`'s
  // in-memory cache, but a cold load with several distinct subjects was
  // still serializing all of those round-trips.
  final distinctSubjectIds = {
    for (final entry in attemptsByTest.entries)
      if (testsById[entry.key] case final test?) test.subjectId,
  };
  final chapterResults = await Future.wait(
    distinctSubjectIds.map(getChapters.call),
  );
  final chaptersBySubject = <String, List<Chapter>>{
    for (final (i, subjectId) in distinctSubjectIds.indexed)
      subjectId: chapterResults[i].when(
        success: (c) => c,
        failure: (_) => const <Chapter>[],
      ),
  };

  final chapterProgressList = <ChapterProgressData>[];

  for (final entry in attemptsByTest.entries) {
    final test = testsById[entry.key];
    if (test == null) continue;

    final chapters = chaptersBySubject[test.subjectId] ?? const <Chapter>[];

    final chapter = test.chapterId != null
        ? chapters.where((c) => c.id == test.chapterId).firstOrNull
        : null;
    final chapterTitle = chapter?.title ?? test.title;

    final testAttempts = entry.value;
    final avgScore =
        testAttempts.map((a) => a.scorePercent ?? 0).reduce((a, b) => a + b) /
        testAttempts.length;

    final sortedAttempts = List<TestAttempt>.from(testAttempts)
      ..sort((a, b) => b.attemptedAt.compareTo(a.attemptedAt));

    chapterProgressList.add(
      ChapterProgressData(
        chapterId: test.chapterId ?? '',
        chapterTitle: chapterTitle,
        subjectId: test.subjectId,
        testId: test.id,
        averagePercent: avgScore,
        attemptsCount: sortedAttempts.length,
        attempts: sortedAttempts,
        latestAttempt: sortedAttempts.firstOrNull,
      ),
    );
  }

  return chapterProgressList;
});

/// Dynamic chapter progress pie chart summary computed dynamically from active filters.
final filteredChapterProgressSummaryProvider =
    FutureProvider<ChapterProgressSummary>((ref) async {
  final attempts = await ref.watch(filteredAttemptsProvider.future);
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
  // One lookup per distinct test, fired in parallel — see
  // `perSubjectProgressProvider`'s `getSubjects` batch for why.
  final questionResults = await Future.wait(
    uniqueTestIds.map(getQuestions.call),
  );
  for (final result in questionResults) {
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

