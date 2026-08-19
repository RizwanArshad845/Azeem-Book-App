import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/board_class.dart';

part 'board_class_dto.freezed.dart';
part 'board_class_dto.g.dart';

@freezed
abstract class BoardClassDto with _$BoardClassDto {
  const BoardClassDto._();

  const factory BoardClassDto({
    required String id,
    required String name,
    @Default(false) bool isEnabled,
  }) = _BoardClassDto;

  factory BoardClassDto.fromJson(Map<String, dynamic> json) =>
      _$BoardClassDtoFromJson(json);

  BoardClass toDomain() =>
      BoardClass(id: id, name: name, isEnabled: isEnabled);

  factory BoardClassDto.fromDomain(BoardClass entity) => BoardClassDto(
    id: entity.id,
    name: entity.name,
    isEnabled: entity.isEnabled,
  );
}
