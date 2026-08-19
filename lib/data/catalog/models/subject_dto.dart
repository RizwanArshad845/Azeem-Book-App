import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/subject.dart';

part 'subject_dto.freezed.dart';
part 'subject_dto.g.dart';

@freezed
abstract class SubjectDto with _$SubjectDto {
  const SubjectDto._();

  const factory SubjectDto({
    required String id,
    required String name,
    required String boardClassId,
  }) = _SubjectDto;

  factory SubjectDto.fromJson(Map<String, dynamic> json) =>
      _$SubjectDtoFromJson(json);

  Subject toDomain() =>
      Subject(id: id, name: name, boardClassId: boardClassId);

  factory SubjectDto.fromDomain(Subject entity) => SubjectDto(
    id: entity.id,
    name: entity.name,
    boardClassId: entity.boardClassId,
  );
}
