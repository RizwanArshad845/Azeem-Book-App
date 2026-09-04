import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/chapter.dart';

part 'chapter_dto.freezed.dart';
part 'chapter_dto.g.dart';

@freezed
abstract class ChapterDto with _$ChapterDto {
  const ChapterDto._();

  const factory ChapterDto({
    required String id,
    required String subjectId,
    required String title,
    required int order,
    @Default(false) bool isFreeSample,
  }) = _ChapterDto;

  factory ChapterDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterDtoFromJson(json);

  Chapter toDomain() => Chapter(
    id: id,
    subjectId: subjectId,
    title: title,
    order: order,
    isFreeSample: isFreeSample,
  );

  factory ChapterDto.fromDomain(Chapter entity) => ChapterDto(
    id: entity.id,
    subjectId: entity.subjectId,
    title: entity.title,
    order: entity.order,
    isFreeSample: entity.isFreeSample,
  );
}
