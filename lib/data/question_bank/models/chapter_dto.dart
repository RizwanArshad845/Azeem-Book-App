import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/question_bank/entities/chapter.dart';

part 'chapter_dto.freezed.dart';
part 'chapter_dto.g.dart';

@freezed
abstract class ChapterDto with _$ChapterDto {
  const factory ChapterDto({
    required int chapter,
    required String title,
    required int mcqCount,
    required int shortCount,
  }) = _ChapterDto;

  factory ChapterDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterDtoFromJson(json);
}

extension ChapterDtoMapper on ChapterDto {
  Chapter toEntity() => Chapter(
        chapter: chapter,
        title: title,
        mcqCount: mcqCount,
        shortCount: shortCount,
      );
}
