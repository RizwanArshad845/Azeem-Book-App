import 'package:freezed_annotation/freezed_annotation.dart';

import 'submission_answer.dart';

part 'test_attempt.freezed.dart';

/// A student's completed submission of a [Test] (project_spec.md §9.2
/// `TestAttempt`). Persisted so later features (`student-progress`,
/// `teacher-students`) can read it back. `weakChapterIds`/`strongChapterIds`
/// are computed once at submission time from this attempt's own answers
/// (see `compute_weak_strong_chapters.dart`) — not a running aggregate
/// across all of the student's attempts.
@freezed
abstract class TestAttempt with _$TestAttempt {
  const factory TestAttempt({
    required String id,
    required String studentId,
    required String testId,
    required List<SubmissionAnswer> answers,
    required double scorePercent,
    List<String>? weakChapterIds,
    List<String>? strongChapterIds,
    int? durationSeconds,
    @Default(false) bool isLiveTestAttempt,
    required DateTime attemptedAt,
  }) = _TestAttempt;
}
