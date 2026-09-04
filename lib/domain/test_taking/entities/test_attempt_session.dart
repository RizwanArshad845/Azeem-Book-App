import 'package:freezed_annotation/freezed_annotation.dart';

import 'attempt_question.dart';

part 'test_attempt_session.freezed.dart';

/// Response of `POST /tests/{id}/start-attempt`: the attempt the student is
/// about to take, the server-authoritative deadline the countdown timer
/// tracks, and the questions to render (answer-key-free — see
/// [AttemptQuestion]).
@freezed
abstract class TestAttemptSession with _$TestAttemptSession {
  const factory TestAttemptSession({
    required String attemptId,
    // Nullable: `FRONTEND_INTEGRATION.md` §6.6 types this `iso8601|null`.
    DateTime? deadlineAt,
    required List<AttemptQuestion> questions,
  }) = _TestAttemptSession;
}
