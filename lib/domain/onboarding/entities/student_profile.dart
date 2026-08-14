import 'package:freezed_annotation/freezed_annotation.dart';

import 'class_level.dart';

part 'student_profile.freezed.dart';

@freezed
abstract class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    required String phoneNumber,
    required String name,
    required String city,
    required String college,
    required ClassLevel classLevel,
    String? classCode,
    required List<String> subjects,
  }) = _StudentProfile;
}
