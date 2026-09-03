import '../../common/result.dart';
import '../repositories/test_attempt_repository.dart';

/// Single-purpose use case: best-effort periodic autosave of a single
/// in-progress answer.
class AutoSaveAnswerUseCase {
  const AutoSaveAnswerUseCase(this._repository);

  final TestAttemptRepository _repository;

  Future<Result<void>> call(
    String attemptId,
    String questionId, {
    int? selectedOptionIndex,
    String? answerText,
  }) => _repository.autoSaveAnswer(
    attemptId,
    questionId,
    selectedOptionIndex: selectedOptionIndex,
    answerText: answerText,
  );
}
