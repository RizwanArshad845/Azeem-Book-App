import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/test_taking/entities/token_judgement.dart';

part 'token_judgement_dto.freezed.dart';
part 'token_judgement_dto.g.dart';

@freezed
abstract class TokenJudgementDto with _$TokenJudgementDto {
  const TokenJudgementDto._();

  const factory TokenJudgementDto({
    required String token,
    required bool used,
  }) = _TokenJudgementDto;

  factory TokenJudgementDto.fromJson(Map<String, dynamic> json) =>
      _$TokenJudgementDtoFromJson(json);

  TokenJudgement toDomain() => TokenJudgement(token: token, used: used);

  factory TokenJudgementDto.fromDomain(TokenJudgement entity) =>
      TokenJudgementDto(token: entity.token, used: entity.used);
}
