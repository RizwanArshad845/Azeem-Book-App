import 'package:freezed_annotation/freezed_annotation.dart';

import 'chapter_score_result.dart';

part 'results_summary.freezed.dart';

@freezed
abstract class ResultsSummary with _$ResultsSummary {
  const factory ResultsSummary({
    required List<ChapterScoreResult> chapterScores,
    required double overallReadinessPercent,
    required double selfAssessmentPercent,
    required double testScorePercent,
  }) = _ResultsSummary;
}
