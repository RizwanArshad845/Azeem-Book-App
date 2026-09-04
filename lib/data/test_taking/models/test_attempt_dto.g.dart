// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_attempt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestAttemptDto _$TestAttemptDtoFromJson(Map<String, dynamic> json) =>
    _TestAttemptDto(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      testId: json['testId'] as String,
      status: $enumDecode(_$TestAttemptStatusEnumMap, json['status']),
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map(
                (e) => SubmissionAnswerDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <SubmissionAnswerDto>[],
      scorePercent: (json['scorePercent'] as num?)?.toDouble(),
      totalMarksAwarded: (json['totalMarksAwarded'] as num?)?.toInt(),
      totalPossibleMarks: (json['totalPossibleMarks'] as num?)?.toInt(),
      weakChapterIds: (json['weakChapterIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      strongChapterIds: (json['strongChapterIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      isLiveTestAttempt: json['isLiveTestAttempt'] as bool? ?? false,
      attemptedAt: DateTime.parse(json['attemptedAt'] as String),
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );

Map<String, dynamic> _$TestAttemptDtoToJson(_TestAttemptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'testId': instance.testId,
      'status': _$TestAttemptStatusEnumMap[instance.status]!,
      'answers': instance.answers,
      'scorePercent': instance.scorePercent,
      'totalMarksAwarded': instance.totalMarksAwarded,
      'totalPossibleMarks': instance.totalPossibleMarks,
      'weakChapterIds': instance.weakChapterIds,
      'strongChapterIds': instance.strongChapterIds,
      'durationSeconds': instance.durationSeconds,
      'isLiveTestAttempt': instance.isLiveTestAttempt,
      'attemptedAt': instance.attemptedAt.toIso8601String(),
      'submittedAt': instance.submittedAt?.toIso8601String(),
    };

const _$TestAttemptStatusEnumMap = {
  TestAttemptStatus.inProgress: 'inProgress',
  TestAttemptStatus.pendingGrading: 'pendingGrading',
  TestAttemptStatus.graded: 'graded',
  TestAttemptStatus.gradingFailed: 'gradingFailed',
};
