import 'package:freezed_annotation/freezed_annotation.dart';

import 'chapter.dart';
import 'mcq_question.dart';
import 'short_question.dart';

part 'question_bank.freezed.dart';

@freezed
abstract class QuestionBank with _$QuestionBank {
  const factory QuestionBank({
    required String subject,
    required List<Chapter> chapters,
    required List<McqQuestion> mcqs,
    required List<ShortQuestion> shortQuestions,
  }) = _QuestionBank;
}
