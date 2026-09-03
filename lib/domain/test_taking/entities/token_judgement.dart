import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_judgement.freezed.dart';

/// A single word-level judgement from AI grading of a short/long answer —
/// whether [token] (an expected-answer keyword) was actually used by the
/// student. Purely display detail for the results/review screens.
@freezed
abstract class TokenJudgement with _$TokenJudgement {
  const factory TokenJudgement({
    required String token,
    required bool used,
  }) = _TokenJudgement;
}
