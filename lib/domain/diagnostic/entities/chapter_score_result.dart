import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_score_result.freezed.dart';

enum ScoreBand { red, yellow, green }

@freezed
abstract class ChapterScoreResult with _$ChapterScoreResult {
  const factory ChapterScoreResult({
    required int chapter,
    required String title,
    required double scorePercent,
    required ScoreBand band,
  }) = _ChapterScoreResult;
}
