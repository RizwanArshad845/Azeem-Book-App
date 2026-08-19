import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/student_cart/entities/cart_item.dart';

part 'cart_item_dto.freezed.dart';
part 'cart_item_dto.g.dart';

@freezed
abstract class CartItemDto with _$CartItemDto {
  const CartItemDto._();

  const factory CartItemDto({
    required String subjectId,
    required String subjectName,
    required int testCount,
    required double price,
    double? discountedPrice,
  }) = _CartItemDto;

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  CartItem toDomain() => CartItem(
    subjectId: subjectId,
    subjectName: subjectName,
    testCount: testCount,
    price: price,
    discountedPrice: discountedPrice,
  );

  factory CartItemDto.fromDomain(CartItem entity) => CartItemDto(
    subjectId: entity.subjectId,
    subjectName: entity.subjectName,
    testCount: entity.testCount,
    price: entity.price,
    discountedPrice: entity.discountedPrice,
  );
}
