import 'package:freezed_annotation/freezed_annotation.dart';

part 'mcq_question.freezed.dart';

@freezed
abstract class McqQuestion with _$McqQuestion {
  const factory McqQuestion({
    required String id,
    required int chapter,
    required String question,
    required List<String> options,
    required int correctIndex,
  }) = _McqQuestion;
}
