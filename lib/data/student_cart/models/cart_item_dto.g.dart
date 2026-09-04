// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => _CartItemDto(
  id: json['id'] as String?,
  subjectId: json['subjectId'] as String,
  subjectName: json['subjectName'] as String?,
  testCount: (json['testCount'] as num?)?.toInt(),
  price: const DecimalStringConverter().fromJson(json['price']),
  discountedPrice: const NullableDecimalStringConverter().fromJson(
    json['discountedPrice'],
  ),
);

Map<String, dynamic> _$CartItemDtoToJson(_CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'testCount': instance.testCount,
      'price': const DecimalStringConverter().toJson(instance.price),
      'discountedPrice': const NullableDecimalStringConverter().toJson(
        instance.discountedPrice,
      ),
    };
