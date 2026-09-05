import 'package:freezed_annotation/freezed_annotation.dart';

import 'submission_answer.dart';

part 'test_attempt.freezed.dart';

/// Grading lifecycle of a [TestAttempt] once raw answers are submitted —
/// `inProgress` (attempt started, not yet submitted) -> `pendingGrading`
/// (submitted, AI grading in flight) -> `graded` (final `scorePercent`/
/// `answers` detail available) or `gradingFailed` (retries exhausted — see
/// `FRONTEND_INTEGRATION.md` §6.6 "Answer persistence & grading UX").
///
/// `unknown` is a decode-only fallback (`@JsonKey(unknownEnumValue: ...)` on
/// `TestAttemptDto.status`) for a wire value that doesn't match any of the
/// above — keeps one unrecognized `status` string from throwing away the
/// entire attempt payload during grading polling (`_pollUntilGraded`).
enum TestAttemptStatus {
  inProgress,
  pendingGrading,
  graded,
  gradingFailed,
  unknown,
}

/// A student's submission of a [Test] (project_spec.md §9.2 `TestAttempt`).
/// Persisted so later features (`student-progress`, `teacher-students`) can
/// read it back. `weakChapterIds`/`strongChapterIds` are computed
/// server-side once at grading time from this attempt's own answers — not a
/// running aggregate across all of the student's attempts.
///
/// "All-or-nothing release" (§6.6): every score/answer field is `null` (or
/// `[]` for `answers`) unless `status == graded` — `scorePercent` is
/// nullable rather than defaulting to `0.0` so an ungraded attempt is never
/// indistinguishable from a real zero score.
@freezed
abstract class TestAttempt with _$TestAttempt {
  const factory TestAttempt({
    required String id,
    required String studentId,
    required String testId,
    required TestAttemptStatus status,
    @Default(<SubmissionAnswer>[]) List<SubmissionAnswer> answers,
    double? scorePercent,
    int? totalMarksAwarded,
    int? totalPossibleMarks,
    List<String>? weakChapterIds,
    List<String>? strongChapterIds,
    int? durationSeconds,
    @Default(false) bool isLiveTestAttempt,
    required DateTime attemptedAt,
    DateTime? submittedAt,
  }) = _TestAttempt;
}
