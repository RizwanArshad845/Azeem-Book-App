import 'package:freezed_annotation/freezed_annotation.dart';

import '../../question_bank/entities/test_question.dart';
import 'test_answer.dart';

part 'test_session.freezed.dart';

enum TestSessionStatus { notStarted, inProgress, completed }

@freezed
abstract class TestSession with _$TestSession {
  const factory TestSession({
    required String sessionId,
    required List<TestQuestion> questions,
    required Map<String, TestAnswer> answers,
    required int currentIndex,
    required TestSessionStatus status,
    required bool consentAcknowledged,
    DateTime? startedAt,
  }) = _TestSession;
}
