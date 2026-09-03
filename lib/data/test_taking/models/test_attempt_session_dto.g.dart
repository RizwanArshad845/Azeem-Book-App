// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_attempt_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestAttemptSessionDto _$TestAttemptSessionDtoFromJson(
  Map<String, dynamic> json,
) => _TestAttemptSessionDto(
  attemptId: json['attemptId'] as String,
  deadlineAt: DateTime.parse(json['deadlineAt'] as String),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => AttemptQuestionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TestAttemptSessionDtoToJson(
  _TestAttemptSessionDto instance,
) => <String, dynamic>{
  'attemptId': instance.attemptId,
  'deadlineAt': instance.deadlineAt.toIso8601String(),
  'questions': instance.questions,
};
