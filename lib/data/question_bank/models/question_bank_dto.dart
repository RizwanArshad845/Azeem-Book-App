import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/question_bank/entities/question_bank.dart';
import 'chapter_dto.dart';
import 'mcq_dto.dart';
import 'short_question_dto.dart';

part 'question_bank_dto.freezed.dart';
part 'question_bank_dto.g.dart';

@freezed
abstract class QuestionBankDto with _$QuestionBankDto {
  const factory QuestionBankDto({
    required String subject,
    required List<ChapterDto> chapters,
    required List<McqDto> mcqs,
    required List<ShortQuestionDto> shortQuestions,
  }) = _QuestionBankDto;

  factory QuestionBankDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionBankDtoFromJson(json);
}

extension QuestionBankDtoMapper on QuestionBankDto {
  QuestionBank toEntity() => QuestionBank(
        subject: subject,
        chapters: chapters.map((c) => c.toEntity()).toList(),
        mcqs: mcqs.map((m) => m.toEntity()).toList(),
        shortQuestions: shortQuestions.map((s) => s.toEntity()).toList(),
      );
}
