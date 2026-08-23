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

/// Groups [questions] by [QuestionType] and folds in the graded [answers] to
/// produce a per-type marks breakdown for the results screen. Pure function —
/// no side effects, so it needs no repository/DI wiring. An answer counts as
/// correct only when `isCorrect == true`; null/false (incl. ungraded text
/// answers) count as wrong. Sections with no questions are omitted.
List<SectionBreakdown> computeSectionBreakdown(
  List<Question> questions,
  List<SubmissionAnswer> answers,
) {
  final answersById = {for (final a in answers) a.questionId: a};
  const order = [
    QuestionType.mcq,
    QuestionType.shortAnswer,
    QuestionType.longAnswer,
  ];

  final result = <SectionBreakdown>[];
  for (final type in order) {
    final sectionQuestions = questions.where((q) => q.type == type);
    if (sectionQuestions.isEmpty) continue;

    var correct = 0;
    var wrong = 0;
    var earned = 0;
    var total = 0;
    for (final q in sectionQuestions) {
      total += q.marks;
      if (answersById[q.id]?.isCorrect == true) {
        correct++;
        earned += q.marks;
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
