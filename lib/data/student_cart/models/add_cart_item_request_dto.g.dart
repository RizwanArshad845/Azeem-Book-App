// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_cart_item_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddCartItemRequestDto _$AddCartItemRequestDtoFromJson(
  Map<String, dynamic> json,
) => _AddCartItemRequestDto(
  subjectId: json['subjectId'] as String,
  discountedPrice: const NullableDecimalStringConverter().fromJson(
    json['discountedPrice'],
  ),
);

Map<String, dynamic> _$AddCartItemRequestDtoToJson(
  _AddCartItemRequestDto instance,
) => <String, dynamic>{
  'subjectId': instance.subjectId,
  'discountedPrice': const NullableDecimalStringConverter().toJson(
    instance.discountedPrice,
  ),
};
