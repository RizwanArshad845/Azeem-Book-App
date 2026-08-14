import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required int chapter,
    required String title,
    required int mcqCount,
    required int shortCount,
  }) = _Chapter;
}
