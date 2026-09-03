import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/test_taking/entities/test_attempt_session.dart';
import 'attempt_question_dto.dart';

part 'test_attempt_session_dto.freezed.dart';
part 'test_attempt_session_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of `POST /tests/{id}/start-attempt`.
@freezed
abstract class TestAttemptSessionDto with _$TestAttemptSessionDto {
  const TestAttemptSessionDto._();

  const factory TestAttemptSessionDto({
    required String attemptId,
    required DateTime deadlineAt,
    required List<AttemptQuestionDto> questions,
  }) = _TestAttemptSessionDto;

  factory TestAttemptSessionDto.fromJson(Map<String, dynamic> json) =>
      _$TestAttemptSessionDtoFromJson(json);

  TestAttemptSession toDomain() => TestAttemptSession(
    attemptId: attemptId,
    deadlineAt: deadlineAt,
    questions: questions.map((q) => q.toDomain()).toList(),
  );
}
