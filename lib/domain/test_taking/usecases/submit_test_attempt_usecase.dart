import '../../catalog/entities/question.dart';
import '../../common/result.dart';
import '../entities/submission_answer.dart';
import '../entities/test_attempt.dart';
import '../repositories/test_attempt_repository.dart';
import 'compute_weak_strong_chapters.dart';
import 'grade_mcq_answer.dart';
import 'grade_text_answer.dart';

/// Grades every question in a test-taking session and submits the resulting
/// [TestAttempt] (project_spec.md §9.2). This is the single orchestration
/// point for grading so the viewmodel stays a thin caller, per §2.2 "S —
/// ViewModels orchestrate only."
class SubmitTestAttemptUseCase {
  const SubmitTestAttemptUseCase(this._repository);

  final TestAttemptRepository _repository;

  /// [rawAnswers] is keyed by `questionId`; entries are either a selected
  /// mcq option index (`int`) or free-text (`String`) depending on the
  /// matching [Question.type]. Missing entries are treated as unanswered.
  Future<Result<TestAttempt>> call({
    required String id,
    required String studentId,
    required String testId,
    required List<Question> questions,
    required Map<String, Object> rawAnswers,
    int? durationSeconds,
    bool isLiveTestAttempt = false,
  }) {
    final answers = <SubmissionAnswer>[];
    for (final question in questions) {
      final raw = rawAnswers[question.id];
      switch (question.type) {
        case QuestionType.mcq:
          answers.add(
            gradeMcqAnswer(
              question: question,
              selectedOptionIndex: raw is int ? raw : null,
            ),
          );
        case QuestionType.shortAnswer:
        case QuestionType.longAnswer:
          answers.add(
            gradeTextAnswer(
              question: question,
              answerText: raw is String ? raw : null,
            ),
          );
      }
    }

    final correctCount = answers.where((a) => a.isCorrect == true).length;
    final scorePercent = questions.isEmpty
        ? 0.0
        : correctCount / questions.length * 100;

    final weakStrong = computeWeakStrongChapters(
      answers: answers,
      questions: questions,
    );

    final attempt = TestAttempt(
      id: id,
      studentId: studentId,
      testId: testId,
      answers: answers,
      scorePercent: scorePercent,
      weakChapterIds: weakStrong.weakChapterIds,
      strongChapterIds: weakStrong.strongChapterIds,
      durationSeconds: durationSeconds,
      isLiveTestAttempt: isLiveTestAttempt,
      attemptedAt: DateTime.now(),
    );

    return _repository.submitAttempt(attempt);
  }
}
