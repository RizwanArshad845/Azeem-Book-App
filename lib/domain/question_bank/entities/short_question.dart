import 'package:freezed_annotation/freezed_annotation.dart';

part 'short_question.freezed.dart';

@freezed
abstract class ShortQuestion with _$ShortQuestion {
  const factory ShortQuestion({
    required String id,
    required int chapter,
    required String question,
    required String modelAnswer,
  }) = _ShortQuestion;
}
