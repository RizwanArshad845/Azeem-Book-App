import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/ebook.dart';

part 'ebook_dto.freezed.dart';
part 'ebook_dto.g.dart';

@freezed
abstract class EbookDto with _$EbookDto {
  const EbookDto._();

  const factory EbookDto({
    required String subjectId,
    required String status,
    int? pageCount,
  }) = _EbookDto;

  factory EbookDto.fromJson(Map<String, dynamic> json) =>
      _$EbookDtoFromJson(json);

  Ebook toDomain() => Ebook(
    subjectId: subjectId,
    status: switch (status) {
      'pending' => EbookStatus.pending,
      'processing' => EbookStatus.processing,
      'ready' => EbookStatus.ready,
      'failed' => EbookStatus.failed,
      _ => throw FormatException('Unknown ebook status: $status'),
    },
    pageCount: pageCount,
  );
}
