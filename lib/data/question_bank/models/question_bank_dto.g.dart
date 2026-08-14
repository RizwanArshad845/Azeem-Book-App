// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bank_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionBankDto _$QuestionBankDtoFromJson(Map<String, dynamic> json) =>
    _QuestionBankDto(
      subject: json['subject'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      mcqs: (json['mcqs'] as List<dynamic>)
          .map((e) => McqDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      shortQuestions: (json['shortQuestions'] as List<dynamic>)
          .map((e) => ShortQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionBankDtoToJson(_QuestionBankDto instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'chapters': instance.chapters,
      'mcqs': instance.mcqs,
      'shortQuestions': instance.shortQuestions,
    };
