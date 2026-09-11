import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/ebook_page.dart';

part 'ebook_page_dto.freezed.dart';
part 'ebook_page_dto.g.dart';

@freezed
abstract class EbookPageDto with _$EbookPageDto {
  const EbookPageDto._();

  const factory EbookPageDto({
    required int pageNumber,
    required String url,
  }) = _EbookPageDto;

  factory EbookPageDto.fromJson(Map<String, dynamic> json) =>
      _$EbookPageDtoFromJson(json);

  EbookPage toDomain() => EbookPage(pageNumber: pageNumber, url: url);
}

@freezed
abstract class EbookPagesResponseDto with _$EbookPagesResponseDto {
  const EbookPagesResponseDto._();

  const factory EbookPagesResponseDto({
    required List<EbookPageDto> pages,
    required int expiresInSeconds,
  }) = _EbookPagesResponseDto;

  factory EbookPagesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EbookPagesResponseDtoFromJson(json);

  EbookPageWindow toDomain() => EbookPageWindow(
    pages: pages.map((p) => p.toDomain()).toList(),
    expiresInSeconds: expiresInSeconds,
  );
}
