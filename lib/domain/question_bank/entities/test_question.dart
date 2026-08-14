import 'package:freezed_annotation/freezed_annotation.dart';

import 'mcq_question.dart';
import 'short_question.dart';

part 'test_question.freezed.dart';

/// Unifies MCQ and short-answer questions into one polymorphic type so the
/// test screen can hold a single `List<TestQuestion>`.
@freezed
sealed class TestQuestion with _$TestQuestion {
  const factory TestQuestion.mcq(McqQuestion question) = TestQuestionMcq;
  const factory TestQuestion.short(ShortQuestion question) = TestQuestionShort;

  const TestQuestion._();

  String get id => when(mcq: (q) => q.id, short: (q) => q.id);

  int get chapter => when(mcq: (q) => q.chapter, short: (q) => q.chapter);

  String get questionText =>
      when(mcq: (q) => q.question, short: (q) => q.question);
}
