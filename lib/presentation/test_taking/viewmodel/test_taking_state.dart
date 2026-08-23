import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/question.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/test_taking/entities/submission_answer.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';

part 'test_taking_state.freezed.dart';

/// Lifecycle of a single test-taking session (project_spec.md §10.2 "no
/// pause / no bottom-nav during an active test").
///
/// - [loadingGate]: purchase-gate check + question load in flight.
/// - [notPurchased]: gate failed — distinct from a generic error so the
///   view can show a clear "purchase this test first" message with a way
///   back, instead of a raw [Failure] (per task brief, not a dead end).
/// - [inProgress]: student is answering questions.
/// - [submitting]: grading + persisting the attempt.
/// - [submitted]: graded [TestTakingState.result] is ready for the results
///   view.
enum TestTakingStatus { loadingGate, notPurchased, inProgress, submitting, submitted }

@freezed
abstract class TestTakingState with _$TestTakingState {
  const TestTakingState._();

  const factory TestTakingState({
    required TestTakingStatus status,
    Test? test,
    @Default(<Question>[]) List<Question> questions,
    @Default(0) int currentIndex,
    @Default(<String, SubmissionAnswer>{}) Map<String, SubmissionAnswer> answers,
    @Default(0) int secondsRemaining,
    TestAttempt? result,
  }) = _TestTakingState;

  /// True when the current question already has a recorded answer — mcq
  /// needs a non-null `selectedOptionIndex`, short/long answer needs
  /// non-empty `answerText`. Gates "Next"/"Submit" per CLAUDE.md's
  /// question-lock rule ("Next question button disabled/greyed out if
  /// answer is not selected/entered").
  bool get canGoNext {
    if (questions.isEmpty || currentIndex >= questions.length) return false;
    final answer = answers[questions[currentIndex].id];
    if (answer == null) return false;
    if (answer.selectedOptionIndex != null) return true;
    final text = answer.answerText;
    return text != null && text.trim().isNotEmpty;
  }
}
