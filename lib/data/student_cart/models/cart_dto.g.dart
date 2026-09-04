// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartDto _$CartDtoFromJson(Map<String, dynamic> json) => _CartDto(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: json['totalAmount'] == null
      ? 0
      : const DecimalStringConverter().fromJson(json['totalAmount']),
);

Map<String, dynamic> _$CartDtoToJson(_CartDto instance) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'items': instance.items,
  'totalAmount': const DecimalStringConverter().toJson(instance.totalAmount),
};
