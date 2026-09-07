import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../core/services/logger.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_cart/usecases/get_purchased_subject_ids_usecase.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/get_attempt_usecase.dart';
import '../../../domain/test_taking/usecases/start_test_attempt_usecase.dart';
import '../../../domain/test_taking/usecases/submit_test_attempt_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart';
import 'test_taking_state.dart';

/// Test-taking session for a single `testId` (§10.2 outside-shell,
/// full-screen, "no pause / no bottom-nav during an active test").
///
/// Per-test instance: `AsyncNotifierProvider.family.autoDispose` so each
/// `testId` gets its own fresh notifier (and its state is torn down, timer
/// included, once the screen is popped) — this project has no
/// `riverpod_generator` dependency (only `flutter_riverpod`), so this is a
/// hand-written family notifier via `AsyncNotifierProvider.family`, not
/// `@riverpod` codegen. This codebase's Riverpod 3.x has no
/// `AsyncValue.valueOrNull` — `.value` is used directly throughout.
class TestTakingViewModel extends AsyncNotifier<TestTakingState> {
  TestTakingViewModel(this.testId);

  final String testId;

  Timer? _timer;

  @override
  Future<TestTakingState> build() async {
    ref.onDispose(() => _timer?.cancel());

    final session = ref.watch(currentUserProvider);
    if (session == null) {
      // Edge case only — router redirect guarantees a resolved session
      // before this route is reachable (mirrors StudentCartViewModel).
      return const TestTakingState(status: TestTakingStatus.loadingGate);
    }

    // Resolve the Test entity. `CatalogRepository`/`GetTestsUseCase` has no
    // "get by id" — same limitation `cartTestsByIdProvider` works around —
    // so fetch the full catalog and find this testId in it.
    final testsResult = await ref.read(getTestsUseCaseProvider)();
    final test = testsResult.when(
      success: (tests) {
        for (final t in tests) {
          if (t.id == testId) return t;
        }
        return null;
      },
      failure: (failure) => throw failure,
    );
    if (test == null) {
      throw const NotFoundFailure('This test could not be found.');
    }

    // Purchase gate (must run before starting an attempt): a student may
    // attempt a test only if it's a free sample or its subject is in their
    // purchased-subject-ids set (bundle-only purchasing — see `CartItem`
    // doc comment).
    if (!test.isFreeSample) {
      final purchasedResult = await sl<GetPurchasedSubjectIdsUseCase>()(
        session.userId!,
      );
      final isPurchased = purchasedResult.when(
        success: (ids) => ids.contains(test.subjectId),
        failure: (_) => false,
      );
      if (!isPurchased) {
        return TestTakingState(status: TestTakingStatus.notPurchased, test: test);
      }
    }

    final sessionResult = await sl<StartTestAttemptUseCase>()(testId);
    final attemptSession = sessionResult.when(
      success: (s) => s,
      failure: (failure) => throw failure,
    );

    // No server-computed deadline (§6.6: `deadlineAt` may be `null`) — fall
    // back to a generous cap rather than crash or end the attempt instantly.
    final deadlineAt =
        attemptSession.deadlineAt ?? DateTime.now().add(const Duration(hours: 24));
    final secondsRemaining = deadlineAt
        .difference(DateTime.now())
        .inSeconds
        .clamp(0, 1 << 31);

    _startTimer();

    return TestTakingState(
      status: TestTakingStatus.inProgress,
      test: test,
      attemptId: attemptSession.attemptId,
      questions: attemptSession.questions,
      currentIndex: 0,
      answers: const {},
      secondsRemaining: secondsRemaining,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state.value;
      if (current == null || current.status != TestTakingStatus.inProgress) {
        return;
      }
      if (current.secondsRemaining <= 1) {
        _timer?.cancel();
        state = AsyncData(current.copyWith(secondsRemaining: 0));
        // Time's up — auto-submit whatever was answered so far.
        submitAttempt();
        return;
      }
      state = AsyncData(
        current.copyWith(secondsRemaining: current.secondsRemaining - 1),
      );
    });
  }

  /// Records/overwrites the selected mcq option for [questionId] —
  /// local-only (Riverpod state), no network call. The complete answer set
  /// is sent in one shot on [submitAttempt] (`FRONTEND_INTEGRATION.md` §6.6
  /// "Answer persistence & grading UX": no per-answer network round trip
  /// during test-taking).
  void selectOption(String questionId, int optionIndex) {
    final current = state.value;
    if (current == null || current.status != TestTakingStatus.inProgress) {
      return;
    }
    final updated = Map<String, SubmissionAnswer>.from(current.answers);
    updated[questionId] = SubmissionAnswer(
      questionId: questionId,
      selectedOptionIndex: optionIndex,
    );
    state = AsyncData(current.copyWith(answers: updated));
  }

  /// Records/overwrites the free-text answer for [questionId] (short or
  /// long answer — same widget, same storage shape) — local-only, see
  /// [selectOption].
  void setTextAnswer(String questionId, String text) {
    final current = state.value;
    if (current == null || current.status != TestTakingStatus.inProgress) {
      return;
    }
    final updated = Map<String, SubmissionAnswer>.from(current.answers);
    updated[questionId] = SubmissionAnswer(questionId: questionId, answerText: text);
    state = AsyncData(current.copyWith(answers: updated));
  }

  void nextQuestion() {
    final current = state.value;
    if (current == null) return;
    if (!current.canGoNext) return;
    if (current.currentIndex >= current.questions.length - 1) return;
    state = AsyncData(current.copyWith(currentIndex: current.currentIndex + 1));
  }

  void previousQuestion() {
    final current = state.value;
    if (current == null) return;
    if (current.currentIndex <= 0) return;
    state = AsyncData(current.copyWith(currentIndex: current.currentIndex - 1));
  }

  void goToQuestion(int index) {
    final current = state.value;
    if (current == null) return;
    if (index < 0 || index >= current.questions.length) return;
    state = AsyncData(current.copyWith(currentIndex: index));
  }

  /// Posts the raw (ungraded) answers, transitions to
  /// [TestTakingStatus.awaitingGrading], and polls until the server reports
  /// `status == graded`. Returns the graded attempt (or `null` on submit
  /// failure — status is reverted to [TestTakingStatus.inProgress] so the
  /// student can retry rather than losing their in-progress answers; `null`
  /// on a polling timeout leaves the state at `awaitingGrading` since the
  /// submission itself already succeeded server-side).
  Future<TestAttempt?> submitAttempt() async {
    final current = state.value;
    if (current == null || current.test == null || current.attemptId == null) {
      return null;
    }
    if (current.status == TestTakingStatus.submitted) return current.result;
    if (current.status == TestTakingStatus.submitting ||
        current.status == TestTakingStatus.awaitingGrading) {
      return null;
    }

    final attemptId = current.attemptId!;
    state = AsyncData(current.copyWith(status: TestTakingStatus.submitting));

    final rawAnswers = <String, Object>{};
    for (final entry in current.answers.entries) {
      final selected = entry.value.selectedOptionIndex;
      final text = entry.value.answerText;
      if (selected != null) {
        rawAnswers[entry.key] = selected;
      } else if (text != null) {
        rawAnswers[entry.key] = text;
      }
    }

    final submitResult = await sl<SubmitTestAttemptUseCase>()(
      attemptId,
      rawAnswers,
    );
    final submitted = submitResult.when(
      success: (_) => true,
      failure: (_) => false,
    );
    if (!submitted) {
      state = AsyncData(current.copyWith(status: TestTakingStatus.inProgress));
      return null;
    }

    // Invalidate immediately so free attempt count and progress update as soon
    // as the attempt is submitted, even before grading poll finishes.
    ref.invalidate(studentTestAttemptsProvider);

    _timer?.cancel();
    final awaitingState = state.value ?? current;
    state = AsyncData(
      awaitingState.copyWith(status: TestTakingStatus.awaitingGrading),
    );

    final graded = await _pollUntilGraded(attemptId);
    final latest = state.value;
    if (latest == null) return null;
    if (graded == null) return null;

    state = AsyncData(
      latest.copyWith(
        status: TestTakingStatus.submitted,
        result: graded,
        gradingProgress: 1.0,
      ),
    );
    // So the Progress tab reflects this attempt immediately without a
    // manual pull-to-refresh — the other progress-derived providers
    // transitively watch this one and cascade-recompute on their own.
    ref.invalidate(studentTestAttemptsProvider);
    return graded;
  }

  /// Polls `GET /attempts/{attemptId}` every 2s (bounded to ~80s total)
  /// until the server reports `status == graded`, or gives up and returns
  /// `null` if grading takes longer than that.
  ///
  /// Also publishes an eased fake-progress value into `state.gradingProgress`
  /// each tick, for `GradingInProgressView`'s progress ring: real grading
  /// finishes in ~10s (confirmed against backend timing data) but the poll
  /// budget is ~80s, so `elapsed/maxElapsed` would sit around 12% right when
  /// it's actually about to finish — worse than no percentage at all. The
  /// `1 - exp(-elapsed/6)` curve instead ramps to ~87% by 12s and plateaus
  /// (capped at 95% until the real `graded` result arrives), the standard
  /// "upload bar" shape.
  Future<TestAttempt?> _pollUntilGraded(String attemptId) async {
    const maxAttempts = 40;
    const interval = Duration(seconds: 2);
    for (var i = 0; i < maxAttempts; i++) {
      // `.autoDispose` doesn't cancel this in-flight loop when the student
      // navigates away from the test-taking screen — without this guard it
      // keeps hitting `GET /attempts/{id}` in the background for the full
      // ~80s budget even after the provider (and its `state` writes) are
      // meaningless.
      if (!ref.mounted) return null;
      await Future<void>.delayed(interval);
      if (!ref.mounted) return null;

      final elapsedSeconds = (i + 1) * interval.inSeconds;
      final progress = math.min(0.95, 1 - math.exp(-elapsedSeconds / 6));
      final current = state.value;
      if (current != null) {
        state = AsyncData(current.copyWith(gradingProgress: progress));
      }

      final result = await sl<GetAttemptUseCase>()(attemptId);
      final attempt = result.when(
        success: (a) => a,
        failure: (failure) {
          // Otherwise indistinguishable from "parsed fine, just not graded
          // yet" — this is the only trace of a request/decode failure
          // (e.g. an unrecognized `status` wire value) during polling, since
          // `LoggingInterceptor` never logs response bodies.
          sl<Logger>().w(
            'Poll #$i for attempt $attemptId failed: ${failure.message}',
          );
          return null;
        },
      );
      if (attempt != null && attempt.status == TestAttemptStatus.unknown) {
        sl<Logger>().w(
          'Poll #$i for attempt $attemptId decoded with an unrecognized '
          'status — backend/DTO status enum likely mismatched.',
        );
      }
      if (attempt?.status == TestAttemptStatus.graded) return attempt;
    }
    return null;
  }
}

final testTakingViewModelProvider = AsyncNotifierProvider.family
    .autoDispose<TestTakingViewModel, TestTakingState, String>(
      TestTakingViewModel.new,
    );
