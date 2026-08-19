import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/campus_directory/entities/campus.dart';

part 'campus_dto.freezed.dart';
part 'campus_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of `/catalog/campuses` per §9.2.
/// Identical field shape for both the dummy and remote datasources so
/// flipping `AppConfig.isMockMode` requires zero call-site changes (§6.1).
@freezed
abstract class CampusDto with _$CampusDto {
  const factory CampusDto({
    required String id,
    required String name,
    required String city,
  }) = _CampusDto;

  const CampusDto._();

  factory CampusDto.fromJson(Map<String, dynamic> json) =>
      _$CampusDtoFromJson(json);

  Campus toDomain() => Campus(id: id, name: name, city: city);

  factory CampusDto.fromDomain(Campus entity) => CampusDto(
        id: entity.id,
        name: entity.name,
        city: entity.city,
      );
}
