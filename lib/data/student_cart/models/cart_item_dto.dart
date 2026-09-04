import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/converters/decimal_json_converter.dart';
import '../../../domain/student_cart/entities/cart_item.dart';

part 'cart_item_dto.freezed.dart';
part 'cart_item_dto.g.dart';

@freezed
abstract class CartItemDto with _$CartItemDto {
  const CartItemDto._();

  const factory CartItemDto({
    // Wire shape is `{id, subjectId, price, discountedPrice}`
    // (`FRONTEND_INTEGRATION.md` §6.5) — the backend doesn't echo back a
    // subject name or test count, so those stay nullable and are resolved
    // client-side from the catalog where displayed, same as
    // `teacher_profile_view.dart`'s `subjectsById[id]?.name ?? id` pattern.
    // `id` is absent from the outgoing add-to-cart request (server-assigned).
    String? id,
    required String subjectId,
    String? subjectName,
    int? testCount,
    @DecimalStringConverter() required double price,
    @NullableDecimalStringConverter() double? discountedPrice,
  }) = _CartItemDto;

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  CartItem toDomain() => CartItem(
    id: id,
    subjectId: subjectId,
    subjectName: subjectName,
    testCount: testCount,
    price: price,
    discountedPrice: discountedPrice,
  );

  factory CartItemDto.fromDomain(CartItem entity) => CartItemDto(
    id: entity.id,
    subjectId: entity.subjectId,
    subjectName: entity.subjectName,
    testCount: entity.testCount,
    price: entity.price,
    discountedPrice: entity.discountedPrice,
  );
}
