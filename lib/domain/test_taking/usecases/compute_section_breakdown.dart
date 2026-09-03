import '../../catalog/entities/question.dart';
import '../entities/submission_answer.dart';

/// One section of the Test Result "Section Breakdown", grouped by
/// [QuestionType]: how many were correct/wrong and the earned vs total marks.
class SectionBreakdown {
  const SectionBreakdown({
    required this.type,
    required this.correct,
    required this.wrong,
    required this.earnedMarks,
    required this.totalMarks,
  });

  final QuestionType type;
  final int correct;
  final int wrong;
  final int earnedMarks;
  final int totalMarks;
}

/// Groups a graded attempt's [answers] by [QuestionType] to produce a
/// per-type marks breakdown for the results screen. Pure function — no side
/// effects, so it needs no repository/DI wiring. Each answer is now fully
/// self-describing (server-graded `type`/`marksAwarded`/`possibleMarks`), so
/// this no longer needs the original question list cross-referenced by id.
/// Answers missing a `type` (still ungraded) are skipped. Sections with no
/// answers are omitted.
List<SectionBreakdown> computeSectionBreakdown(List<SubmissionAnswer> answers) {
  const order = [
    QuestionType.mcq,
    QuestionType.shortAnswer,
    QuestionType.longAnswer,
  ];

  final result = <SectionBreakdown>[];
  for (final type in order) {
    final sectionAnswers = answers.where((a) => a.type == type);
    if (sectionAnswers.isEmpty) continue;

    var correct = 0;
    var wrong = 0;
    var earned = 0;
    var total = 0;
    for (final answer in sectionAnswers) {
      total += answer.possibleMarks ?? 0;
      if (answer.isCorrect == true) {
        correct++;
        earned += answer.marksAwarded ?? 0;
      } else {
        wrong++;
      }
    }
    result.add(SectionBreakdown(
      type: type,
      correct: correct,
      wrong: wrong,
      earnedMarks: earned,
      totalMarks: total,
    ));
  }
  return result;
}
