import 'dart:math';

import '../../question_bank/entities/question_bank.dart';
import '../../question_bank/entities/test_question.dart';
import '../entities/test_session.dart';

/// Builds a randomized test session: [totalQuestions] sampled from the
/// question bank, proportionally split across chapters by MCQ pool size,
/// plus [shortQuestionCount] short-answer questions sampled uniformly at
/// random across the whole bank, then shuffled together.
///
/// A fresh `Random()` is created on every call (never shared/seeded/memoized)
/// so every student gets a different question set and order each time they
/// start a test.
class BuildTestSessionUseCase {
  const BuildTestSessionUseCase();

  TestSession call({
    required QuestionBank questionBank,
    required int totalQuestions,
    int shortQuestionCount = 0,
  }) {
    final random = Random();
    final chapters = questionBank.chapters;

    final chapterMcqPoolSizes = <int, int>{
      for (final c in chapters) c.chapter: c.mcqCount,
    };
    final chapterAllocations = _largestRemainderAllocate<int>(
      weights: chapterMcqPoolSizes,
      total: totalQuestions,
    );

    final selected = <TestQuestion>[];
    for (final chapter in chapters) {
      final allocation = chapterAllocations[chapter.chapter] ?? 0;
      if (allocation == 0) continue;

      final mcqPool = questionBank.mcqs
          .where((m) => m.chapter == chapter.chapter)
          .toList()
        ..shuffle(random);

      final mcqCount = allocation.clamp(0, mcqPool.length);
      selected.addAll(mcqPool.take(mcqCount).map(TestQuestion.mcq));
    }

    final shortPool = questionBank.shortQuestions.toList()..shuffle(random);
    final shortCount = shortQuestionCount.clamp(0, shortPool.length);
    selected.addAll(shortPool.take(shortCount).map(TestQuestion.short));

    selected.shuffle(random);

    return TestSession(
      sessionId: '${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}',
      questions: selected,
      answers: const {},
      currentIndex: 0,
      status: TestSessionStatus.notStarted,
      consentAcknowledged: false,
    );
  }

  /// Largest-remainder (Hamilton) apportionment: distributes [total] items
  /// across [weights] proportionally while guaranteeing the allocations sum
  /// to exactly [total].
  Map<K, int> _largestRemainderAllocate<K>({
    required Map<K, int> weights,
    required int total,
  }) {
    final totalWeight = weights.values.fold<int>(0, (a, b) => a + b);
    if (totalWeight <= 0) {
      return {for (final k in weights.keys) k: 0};
    }

    final exact = <K, double>{};
    final result = <K, int>{};
    var allocated = 0;
    for (final entry in weights.entries) {
      final value = entry.value / totalWeight * total;
      exact[entry.key] = value;
      result[entry.key] = value.floor();
      allocated += result[entry.key]!;
    }

    var remaining = total - allocated;
    final byRemainderDesc = weights.keys.toList()
      ..sort((a, b) =>
          (exact[b]! - result[b]!).compareTo(exact[a]! - result[a]!));

    for (var i = 0; i < remaining && i < byRemainderDesc.length; i++) {
      final key = byRemainderDesc[i];
      result[key] = result[key]! + 1;
    }

    return result;
  }
}
