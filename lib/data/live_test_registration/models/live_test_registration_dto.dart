import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/live_test_registration/entities/live_test_registration.dart';

part 'live_test_registration_dto.freezed.dart';
part 'live_test_registration_dto.g.dart';

@freezed
abstract class LiveTestRegistrationDto with _$LiveTestRegistrationDto {
  const LiveTestRegistrationDto._();

  const factory LiveTestRegistrationDto({
    required String id,
    required String studentId,
    required String testId,
    required DateTime registeredAt,
    double? finalScore,
    int? timingSeconds,
    int? prizeRank,
  }) = _LiveTestRegistrationDto;

  factory LiveTestRegistrationDto.fromJson(Map<String, dynamic> json) =>
      _$LiveTestRegistrationDtoFromJson(json);

  LiveTestRegistration toDomain() => LiveTestRegistration(
    id: id,
    studentId: studentId,
    testId: testId,
    registeredAt: registeredAt,
    finalScore: finalScore,
    timingSeconds: timingSeconds,
    prizeRank: prizeRank,
  );

  factory LiveTestRegistrationDto.fromDomain(LiveTestRegistration entity) =>
      LiveTestRegistrationDto(
        id: entity.id,
        studentId: entity.studentId,
        testId: entity.testId,
        registeredAt: entity.registeredAt,
        finalScore: entity.finalScore,
        timingSeconds: entity.timingSeconds,
        prizeRank: entity.prizeRank,
      );
}
