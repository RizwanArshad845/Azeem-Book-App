import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/student_onboarding/entities/teacher_option.dart';

part 'teacher_option_dto.freezed.dart';
part 'teacher_option_dto.g.dart';

/// THROWAWAY DTO mirroring [TeacherOption] — see that entity's doc comment
/// for why this doesn't read from `teacher-onboarding`.
@freezed
abstract class TeacherOptionDto with _$TeacherOptionDto {
  const TeacherOptionDto._();

  const factory TeacherOptionDto({
    required String id,
    required String name,
    required String campusId,
    required List<String> subjectIds,
  }) = _TeacherOptionDto;

  factory TeacherOptionDto.fromJson(Map<String, dynamic> json) =>
      _$TeacherOptionDtoFromJson(json);

  TeacherOption toDomain() =>
      TeacherOption(id: id, name: name, campusId: campusId, subjectIds: subjectIds);

  factory TeacherOptionDto.fromDomain(TeacherOption entity) => TeacherOptionDto(
    id: entity.id,
    name: entity.name,
    campusId: entity.campusId,
    subjectIds: entity.subjectIds,
  );
}
