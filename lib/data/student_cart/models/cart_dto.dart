import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/converters/decimal_json_converter.dart';
import '../../../domain/student_cart/entities/cart.dart';
import 'cart_item_dto.dart';

part 'cart_dto.freezed.dart';
part 'cart_dto.g.dart';

@freezed
abstract class CartDto with _$CartDto {
  const CartDto._();

  const factory CartDto({
    required String id,
    required String studentId,
    List<CartItemDto>? items,
    @Default(0) @DecimalStringConverter() double totalAmount,
  }) = _CartDto;

  factory CartDto.fromJson(Map<String, dynamic> json) =>
      _$CartDtoFromJson(json);

  Cart toDomain() => Cart(
    id: id,
    studentId: studentId,
    items: items?.map((i) => i.toDomain()).toList(),
    totalAmount: totalAmount,
  );

  factory CartDto.fromDomain(Cart entity) => CartDto(
    id: entity.id,
    studentId: entity.studentId,
    items: entity.items?.map(CartItemDto.fromDomain).toList(),
    totalAmount: entity.totalAmount,
  );
}
