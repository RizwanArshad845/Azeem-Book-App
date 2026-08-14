import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/question_bank/entities/short_question.dart';

part 'short_question_dto.freezed.dart';
part 'short_question_dto.g.dart';

@freezed
abstract class ShortQuestionDto with _$ShortQuestionDto {
  const factory ShortQuestionDto({
    required String id,
    required int chapter,
    required String question,
    required String modelAnswer,
  }) = _ShortQuestionDto;

  factory ShortQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$ShortQuestionDtoFromJson(json);
}

extension ShortQuestionDtoMapper on ShortQuestionDto {
  ShortQuestion toEntity() => ShortQuestion(
        id: id,
        chapter: chapter,
        question: question,
        modelAnswer: modelAnswer,
      );
}
