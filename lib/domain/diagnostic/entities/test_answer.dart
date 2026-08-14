import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_answer.freezed.dart';

@freezed
abstract class TestAnswer with _$TestAnswer {
  const factory TestAnswer({
    required String questionId,
    required int chapter,
    required bool isMcq,
    int? selectedIndex,
    String? textAnswer,
    required double scoreFraction,
  }) = _TestAnswer;
}
