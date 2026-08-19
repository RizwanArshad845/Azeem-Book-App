// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => _CartItemDto(
  subjectId: json['subjectId'] as String,
  subjectName: json['subjectName'] as String,
  testCount: (json['testCount'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CartItemDtoToJson(_CartItemDto instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'testCount': instance.testCount,
      'price': instance.price,
      'discountedPrice': instance.discountedPrice,
    };
