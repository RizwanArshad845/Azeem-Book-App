import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/question_bank/entities/mcq_question.dart';

part 'mcq_dto.freezed.dart';
part 'mcq_dto.g.dart';

@freezed
abstract class McqDto with _$McqDto {
  const factory McqDto({
    required String id,
    required int chapter,
    required String question,
    required List<String> options,
    required int correctIndex,
  }) = _McqDto;

  factory McqDto.fromJson(Map<String, dynamic> json) => _$McqDtoFromJson(json);
}

extension McqDtoMapper on McqDto {
  McqQuestion toEntity() => McqQuestion(
        id: id,
        chapter: chapter,
        question: question,
        options: options,
        correctIndex: correctIndex,
      );
}
