import '../../catalog/entities/question.dart';
import '../entities/submission_answer.dart';

/// Result of [computeWeakStrongChapters]: FKs to `Chapter.id`
/// (project_spec.md §9.2 `TestAttempt.weakChapterIds`/`strongChapterIds`).
class WeakStrongChapters {
  const WeakStrongChapters({required this.weakChapterIds, required this.strongChapterIds});

  final List<String> weakChapterIds;
  final List<String> strongChapterIds;
}

/// Groups [answers] by their [Question.chapterId] and computes each
/// chapter's correct-answer percentage within this single attempt.
///
/// Thresholds are a Phase-1 choice (§9.2 doesn't specify exact numbers):
/// chapters scoring `< 50%` are "weak", chapters scoring `> 75%` are
/// "strong". Chapters landing in `[50, 75]` are neither.
WeakStrongChapters computeWeakStrongChapters({
  required List<SubmissionAnswer> answers,
  required List<Question> questions,
}) {
  final questionsById = {for (final q in questions) q.id: q};

  final correctByChapter = <String, int>{};
  final totalByChapter = <String, int>{};

  for (final answer in answers) {
    final question = questionsById[answer.questionId];
    if (question == null) continue;
    final chapterId = question.chapterId;
    totalByChapter.update(chapterId, (v) => v + 1, ifAbsent: () => 1);
    if (answer.isCorrect == true) {
      correctByChapter.update(chapterId, (v) => v + 1, ifAbsent: () => 1);
    }
  }

  final weak = <String>[];
  final strong = <String>[];
  for (final entry in totalByChapter.entries) {
    final chapterId = entry.key;
    final total = entry.value;
    if (total == 0) continue;
    final correct = correctByChapter[chapterId] ?? 0;
    final percent = correct / total * 100;
    if (percent < 50) {
      weak.add(chapterId);
    } else if (percent > 75) {
      strong.add(chapterId);
    }
  }

  return WeakStrongChapters(weakChapterIds: weak, strongChapterIds: strong);
}
