// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EarningsRecordDto _$EarningsRecordDtoFromJson(Map<String, dynamic> json) =>
    _EarningsRecordDto(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String?,
      salesmanId: json['salesmanId'] as String?,
      studentId: json['studentId'] as String,
      amount: const DecimalStringConverter().fromJson(json['amount']),
      triggerEvent: $enumDecode(
        _$EarningsTriggerEventEnumMap,
        json['triggerEvent'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EarningsRecordDtoToJson(_EarningsRecordDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'salesmanId': instance.salesmanId,
      'studentId': instance.studentId,
      'amount': const DecimalStringConverter().toJson(instance.amount),
      'triggerEvent': _$EarningsTriggerEventEnumMap[instance.triggerEvent]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$EarningsTriggerEventEnumMap = {
  EarningsTriggerEvent.paidPackPurchase: 'paidPackPurchase',
};
