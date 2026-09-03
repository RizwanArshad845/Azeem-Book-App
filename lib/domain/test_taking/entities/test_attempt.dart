import 'package:freezed_annotation/freezed_annotation.dart';

import 'submission_answer.dart';

part 'test_attempt.freezed.dart';

/// Grading lifecycle of a [TestAttempt] once raw answers are submitted —
/// `submitted` (queued) -> `grading` (AI grading in flight) -> `graded`
/// (final `scorePercent`/`answers` detail available).
enum TestAttemptStatus { submitted, grading, graded }

/// A student's submission of a [Test] (project_spec.md §9.2 `TestAttempt`).
/// Persisted so later features (`student-progress`, `teacher-students`) can
/// read it back. `weakChapterIds`/`strongChapterIds` are computed
/// server-side once at grading time from this attempt's own answers — not a
/// running aggregate across all of the student's attempts.
@freezed
abstract class TestAttempt with _$TestAttempt {
  const factory TestAttempt({
    required String id,
    required String studentId,
    required String testId,
    required TestAttemptStatus status,
    @Default(<SubmissionAnswer>[]) List<SubmissionAnswer> answers,
    @Default(0.0) double scorePercent,
    int? totalMarksAwarded,
    int? totalPossibleMarks,
    List<String>? weakChapterIds,
    List<String>? strongChapterIds,
    int? durationSeconds,
    @Default(false) bool isLiveTestAttempt,
    required DateTime attemptedAt,
  }) = _TestAttempt;
}
