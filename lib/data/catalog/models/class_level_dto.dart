import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/class_level.dart';

part 'class_level_dto.freezed.dart';
part 'class_level_dto.g.dart';

@freezed
abstract class ClassLevelDto with _$ClassLevelDto {
  const ClassLevelDto._();

  const factory ClassLevelDto({
    required String id,
    required String name,
    @Default(false) bool isEnabled,
  }) = _ClassLevelDto;

  factory ClassLevelDto.fromJson(Map<String, dynamic> json) =>
      _$ClassLevelDtoFromJson(json);

  ClassLevel toDomain() =>
      ClassLevel(id: id, name: name, isEnabled: isEnabled);

  factory ClassLevelDto.fromDomain(ClassLevel entity) => ClassLevelDto(
    id: entity.id,
    name: entity.name,
    isEnabled: entity.isEnabled,
  );
}
