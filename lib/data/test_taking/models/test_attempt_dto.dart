import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/test_taking/entities/test_attempt.dart';
import 'submission_answer_dto.dart';

part 'test_attempt_dto.freezed.dart';
part 'test_attempt_dto.g.dart';

@freezed
abstract class TestAttemptDto with _$TestAttemptDto {
  const TestAttemptDto._();

  const factory TestAttemptDto({
    required String id,
    required String studentId,
    required String testId,
    required List<SubmissionAnswerDto> answers,
    required double scorePercent,
    List<String>? weakChapterIds,
    List<String>? strongChapterIds,
    int? durationSeconds,
    @Default(false) bool isLiveTestAttempt,
    required DateTime attemptedAt,
  }) = _TestAttemptDto;

  factory TestAttemptDto.fromJson(Map<String, dynamic> json) =>
      _$TestAttemptDtoFromJson(json);

  TestAttempt toDomain() => TestAttempt(
    id: id,
    studentId: studentId,
    testId: testId,
    answers: answers.map((a) => a.toDomain()).toList(),
    scorePercent: scorePercent,
    weakChapterIds: weakChapterIds,
    strongChapterIds: strongChapterIds,
    durationSeconds: durationSeconds,
    isLiveTestAttempt: isLiveTestAttempt,
    attemptedAt: attemptedAt,
  );

  factory TestAttemptDto.fromDomain(TestAttempt entity) => TestAttemptDto(
    id: entity.id,
    studentId: entity.studentId,
    testId: entity.testId,
    answers: entity.answers.map(SubmissionAnswerDto.fromDomain).toList(),
    scorePercent: entity.scorePercent,
    weakChapterIds: entity.weakChapterIds,
    strongChapterIds: entity.strongChapterIds,
    durationSeconds: entity.durationSeconds,
    isLiveTestAttempt: entity.isLiveTestAttempt,
    attemptedAt: entity.attemptedAt,
  );
}
