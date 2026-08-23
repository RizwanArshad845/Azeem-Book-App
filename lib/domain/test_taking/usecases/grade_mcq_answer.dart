import '../../catalog/entities/question.dart';
import '../entities/submission_answer.dart';

/// Grades a single mcq [Question] against the student's selected option
/// index (project_spec.md §9.2 — `isCorrect = selectedOptionIndex ==
/// question.correctOptionIndex`). Not AI-graded, so `gradedByAi` stays
/// `false`.
SubmissionAnswer gradeMcqAnswer({
  required Question question,
  required int? selectedOptionIndex,
}) {
  assert(question.type == QuestionType.mcq, 'gradeMcqAnswer expects an mcq Question');
  return SubmissionAnswer(
    questionId: question.id,
    selectedOptionIndex: selectedOptionIndex,
    isCorrect: selectedOptionIndex != null &&
        selectedOptionIndex == question.correctOptionIndex,
    gradedByAi: false,
    solutionExplanation: question.solutionExplanation,
  );
}
