// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_judgement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenJudgementDto _$TokenJudgementDtoFromJson(Map<String, dynamic> json) =>
    _TokenJudgementDto(
      token: json['token'] as String,
      used: json['usedMeaningfully'] as bool,
    );

Map<String, dynamic> _$TokenJudgementDtoToJson(_TokenJudgementDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'usedMeaningfully': instance.used,
    };
