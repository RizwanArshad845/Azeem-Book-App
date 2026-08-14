import '../../question_bank/entities/chapter.dart';
import '../entities/chapter_score_result.dart';
import '../entities/results_summary.dart';
import '../entities/self_assessment_ratings.dart';
import '../entities/test_session.dart';

/// Overall readiness = [selfAssessmentWeight] * self-assessment% +
/// [testScoreWeight] * test score%. Weights are passed in by the caller
/// (from `core/config/app_config.dart`) since domain cannot import core.
class CalculateResultsUseCase {
  const CalculateResultsUseCase();

  ResultsSummary call({
    required TestSession session,
    required SelfAssessmentRatings selfAssessment,
    required List<Chapter> chapters,
    required double selfAssessmentWeight,
    required double testScoreWeight,
  }) {
    final chapterScores = <ChapterScoreResult>[];
    final allFractions = <double>[];

    for (final chapter in chapters) {
      final chapterAnswers = session.answers.values
          .where((a) => a.chapter == chapter.chapter)
          .toList();

      final avg = chapterAnswers.isEmpty
          ? 0.0
          : chapterAnswers.map((a) => a.scoreFraction).reduce((a, b) => a + b) /
              chapterAnswers.length;
      final percent = avg * 100;

      allFractions.addAll(chapterAnswers.map((a) => a.scoreFraction));

      chapterScores.add(ChapterScoreResult(
        chapter: chapter.chapter,
        title: chapter.title,
        scorePercent: percent,
        band: _bandFor(percent),
      ));
    }

    final testScorePercent = allFractions.isEmpty
        ? 0.0
        : allFractions.reduce((a, b) => a + b) / allFractions.length * 100;

    final selfAssessmentPercent =
        ((selfAssessment.averageRating - 1) / 4 * 100).clamp(0.0, 100.0);

    final overallReadinessPercent = selfAssessmentWeight * selfAssessmentPercent +
        testScoreWeight * testScorePercent;

    return ResultsSummary(
      chapterScores: chapterScores,
      overallReadinessPercent: overallReadinessPercent,
      selfAssessmentPercent: selfAssessmentPercent,
      testScorePercent: testScorePercent,
    );
  }

  ScoreBand _bandFor(double percent) {
    if (percent < 50) return ScoreBand.red;
    if (percent <= 75) return ScoreBand.yellow;
    return ScoreBand.green;
  }
}
