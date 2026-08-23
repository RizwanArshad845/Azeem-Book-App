import '../../catalog/entities/question.dart';
import '../entities/submission_answer.dart';

/// Dummy AI-grading stub for `shortAnswer`/`longAnswer` questions (real
/// Gemini OCR/text grading is explicitly Phase 2 per project_spec.md §11).
///
/// Grading heuristic (Phase-1 placeholder, §9.2 doesn't specify one):
/// tokenize both the student's [answerText] and the question's
/// `expectedAnswer` (lowercase, strip punctuation, split on whitespace),
/// then compute `ratio = sharedWords / expectedWords`. `isCorrect = ratio >=
/// 0.5`. Always sets `gradedByAi: true` for these two question types.
SubmissionAnswer gradeTextAnswer({
  required Question question,
  required String? answerText,
}) {
  assert(
    question.type == QuestionType.shortAnswer ||
        question.type == QuestionType.longAnswer,
    'gradeTextAnswer expects a shortAnswer/longAnswer Question',
  );

  final expectedWords = _tokenize(question.expectedAnswer);
  final studentWords = _tokenize(answerText);

  final ratio = expectedWords.isEmpty
      ? 0.0
      : expectedWords.intersection(studentWords).length / expectedWords.length;

  return SubmissionAnswer(
    questionId: question.id,
    answerText: answerText,
    isCorrect: ratio >= 0.5,
    gradedByAi: true,
    solutionExplanation: question.solutionExplanation,
  );
}

Set<String> _tokenize(String? text) {
  if (text == null || text.trim().isEmpty) return const <String>{};
  final stripped = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), ' ');
  return stripped.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
}
