// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => _CartItemDto(
  testId: json['testId'] as String,
  price: (json['price'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CartItemDtoToJson(_CartItemDto instance) =>
    <String, dynamic>{
      'testId': instance.testId,
      'price': instance.price,
      'discountedPrice': instance.discountedPrice,
    };
