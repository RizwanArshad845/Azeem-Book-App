import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_cart/usecases/get_purchased_test_ids_usecase.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/submit_test_attempt_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import 'test_taking_state.dart';

/// Test-taking session for a single `testId` (§10.2 outside-shell,
/// full-screen, "no pause / no bottom-nav during an active test").
///
/// Per-test instance: `AsyncNotifierProvider.family.autoDispose` so each
/// `testId` gets its own fresh notifier (and its state is torn down, timer
/// included, once the screen is popped) — this project has no
/// `riverpod_generator` dependency (only `flutter_riverpod`), so this is a
/// hand-written family notifier via `AsyncNotifierProvider.family`, not
/// `@riverpod` codegen (confirmed against `flutter_riverpod: ^3.4.2`'s
/// public API in `riverpod-3.4.2/lib/src/providers/async_notifier/`).
/// Also note: this codebase's Riverpod 3.x has no `AsyncValue.valueOrNull`
/// — `.value` is used directly throughout, matching the rest of the app.
class TestTakingViewModel extends AsyncNotifier<TestTakingState> {
  TestTakingViewModel(this.testId);

  final String testId;

  /// No fixed per-test duration exists in project_spec.md §9.2 (only
  /// `liveTest.liveDate` is modeled, not a duration) — Phase-1 placeholder:
  /// every non-live test gets a generous flat 30 minutes.
  static const int _defaultDurationSeconds = 30 * 60;

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

    // Purchase gate (must run before questions are loaded): a student may
    // attempt a test only if it's a free sample or its id is in their
    // purchased-test-ids set.
    if (!test.isFreeSample) {
      final purchasedResult = await sl<GetPurchasedTestIdsUseCase>()(
        session.userId,
      );
      final isPurchased = purchasedResult.when(
        success: (ids) => ids.contains(test.id),
        failure: (_) => false,
      );
      if (!isPurchased) {
        return TestTakingState(status: TestTakingStatus.notPurchased, test: test);
      }
    }

    final questionsResult = await ref.read(getQuestionsUseCaseProvider)(testId);
    final questions = questionsResult.when(
      success: (qs) => qs,
      failure: (failure) => throw failure,
    );

    _startTimer();

    return TestTakingState(
      status: TestTakingStatus.inProgress,
      test: test,
      questions: questions,
      currentIndex: 0,
      answers: const {},
      secondsRemaining: _defaultDurationSeconds,
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

  /// Records/overwrites the selected mcq option for [questionId].
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
  /// long answer — same widget, same storage shape).
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

  /// Grades every question via the domain use cases, submits the resulting
  /// [TestAttempt], and transitions to [TestTakingStatus.submitted] on
  /// success. Returns the graded attempt (or `null` on failure — status is
  /// reverted to [TestTakingStatus.inProgress] so the student can retry
  /// rather than losing their in-progress answers).
  Future<TestAttempt?> submitAttempt() async {
    final current = state.value;
    if (current == null || current.test == null) return null;
    if (current.status == TestTakingStatus.submitted) return current.result;
    if (current.status == TestTakingStatus.submitting) return null;

    final session = ref.read(currentUserProvider);
    if (session == null) return null;

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

    final elapsed = _defaultDurationSeconds - current.secondsRemaining;

    final result = await sl<SubmitTestAttemptUseCase>()(
      id: 'attempt-${session.userId}-${DateTime.now().millisecondsSinceEpoch}',
      studentId: session.userId,
      testId: testId,
      questions: current.questions,
      rawAnswers: rawAnswers,
      durationSeconds: elapsed,
      isLiveTestAttempt: current.test!.isLive,
    );

    return result.when(
      success: (attempt) {
        _timer?.cancel();
        state = AsyncData(
          current.copyWith(status: TestTakingStatus.submitted, result: attempt),
        );
        return attempt;
      },
      failure: (_) {
        // Keep the student's answers intact so they can retry submitting.
        state = AsyncData(current.copyWith(status: TestTakingStatus.inProgress));
        return null;
      },
    );
  }
}

final testTakingViewModelProvider = AsyncNotifierProvider.family
    .autoDispose<TestTakingViewModel, TestTakingState, String>(
      TestTakingViewModel.new,
    );
