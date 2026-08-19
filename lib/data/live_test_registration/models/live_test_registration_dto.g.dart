// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_test_registration_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveTestRegistrationDto _$LiveTestRegistrationDtoFromJson(
  Map<String, dynamic> json,
) => _LiveTestRegistrationDto(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  testId: json['testId'] as String,
  registeredAt: DateTime.parse(json['registeredAt'] as String),
  finalScore: (json['finalScore'] as num?)?.toDouble(),
  timingSeconds: (json['timingSeconds'] as num?)?.toInt(),
  prizeRank: (json['prizeRank'] as num?)?.toInt(),
);

Map<String, dynamic> _$LiveTestRegistrationDtoToJson(
  _LiveTestRegistrationDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'testId': instance.testId,
  'registeredAt': instance.registeredAt.toIso8601String(),
  'finalScore': instance.finalScore,
  'timingSeconds': instance.timingSeconds,
  'prizeRank': instance.prizeRank,
};
