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
    // `unknownEnumValue` so a backend `status` string this DTO doesn't
    // recognize maps to `TestAttemptStatus.unknown` instead of throwing and
    // losing the whole attempt payload (see enum doc comment).
    @JsonKey(unknownEnumValue: TestAttemptStatus.unknown)
    required TestAttemptStatus status,
    @Default(<SubmissionAnswerDto>[]) List<SubmissionAnswerDto> answers,
    double? scorePercent,
    int? totalMarksAwarded,
    int? totalPossibleMarks,
    List<String>? weakChapterIds,
    List<String>? strongChapterIds,
    int? durationSeconds,
    @Default(false) bool isLiveTestAttempt,
    required DateTime attemptedAt,
    DateTime? submittedAt,
  }) = _TestAttemptDto;

  factory TestAttemptDto.fromJson(Map<String, dynamic> json) =>
      _$TestAttemptDtoFromJson(json);

  TestAttempt toDomain() => TestAttempt(
    id: id,
    studentId: studentId,
    testId: testId,
    status: status,
    answers: answers.map((a) => a.toDomain()).toList(),
    scorePercent: scorePercent,
    totalMarksAwarded: totalMarksAwarded,
    totalPossibleMarks: totalPossibleMarks,
    weakChapterIds: weakChapterIds,
    strongChapterIds: strongChapterIds,
    durationSeconds: durationSeconds,
    isLiveTestAttempt: isLiveTestAttempt,
    attemptedAt: attemptedAt,
    submittedAt: submittedAt,
  );

  factory TestAttemptDto.fromDomain(TestAttempt entity) => TestAttemptDto(
    id: entity.id,
    studentId: entity.studentId,
    testId: entity.testId,
    status: entity.status,
    answers: entity.answers.map(SubmissionAnswerDto.fromDomain).toList(),
    scorePercent: entity.scorePercent,
    totalMarksAwarded: entity.totalMarksAwarded,
    totalPossibleMarks: entity.totalPossibleMarks,
    weakChapterIds: entity.weakChapterIds,
    strongChapterIds: entity.strongChapterIds,
    durationSeconds: entity.durationSeconds,
    isLiveTestAttempt: entity.isLiveTestAttempt,
    attemptedAt: entity.attemptedAt,
    submittedAt: entity.submittedAt,
  );
}
