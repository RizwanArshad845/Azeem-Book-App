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
      answers: (json['answers'] as List<dynamic>)
          .map((e) => SubmissionAnswerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      scorePercent: (json['scorePercent'] as num).toDouble(),
      weakChapterIds: (json['weakChapterIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      strongChapterIds: (json['strongChapterIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      isLiveTestAttempt: json['isLiveTestAttempt'] as bool? ?? false,
      attemptedAt: DateTime.parse(json['attemptedAt'] as String),
    );

Map<String, dynamic> _$TestAttemptDtoToJson(_TestAttemptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'testId': instance.testId,
      'answers': instance.answers,
      'scorePercent': instance.scorePercent,
      'weakChapterIds': instance.weakChapterIds,
      'strongChapterIds': instance.strongChapterIds,
      'durationSeconds': instance.durationSeconds,
      'isLiveTestAttempt': instance.isLiveTestAttempt,
      'attemptedAt': instance.attemptedAt.toIso8601String(),
    };
