import '../../common/result.dart';
import '../repositories/test_attempt_repository.dart';

/// Submits the raw (ungraded) answers collected during a test-taking
/// session — grading now happens server-side (§backend.md §4.6: client
/// grading must be re-validated, not trusted verbatim), so this use case
/// only kicks off the submit; the caller polls `GetAttemptUseCase` for the
/// graded result.
class SubmitTestAttemptUseCase {
  const SubmitTestAttemptUseCase(this._repository);

  final TestAttemptRepository _repository;

  /// [rawAnswers] is keyed by `questionId`; entries are either a selected
  /// mcq option index (`int`) or free-text (`String`). Missing entries are
  /// treated as unanswered.
  Future<Result<void>> call(
    String testId,
    String attemptId,
    Map<String, Object> rawAnswers,
  ) => _repository.submitAttempt(testId, attemptId, rawAnswers);
}
