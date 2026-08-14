import 'package:freezed_annotation/freezed_annotation.dart';

part 'self_assessment_ratings.freezed.dart';

/// Confidence rating (1-5) per chapter id, default 3.
@freezed
abstract class SelfAssessmentRatings with _$SelfAssessmentRatings {
  const factory SelfAssessmentRatings({
    required Map<int, int> ratingsByChapter,
  }) = _SelfAssessmentRatings;

  const SelfAssessmentRatings._();

  double get averageRating {
    if (ratingsByChapter.isEmpty) return 3;
    final total = ratingsByChapter.values.fold<int>(0, (a, b) => a + b);
    return total / ratingsByChapter.length;
  }
}
