import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/converters/decimal_json_converter.dart';

part 'add_cart_item_request_dto.freezed.dart';
part 'add_cart_item_request_dto.g.dart';

/// Outgoing add-to-cart request body — mirrors the backend's
/// `CartItemInputSerializer` exactly (`subjectId`, `discountedPrice` only).
/// `price` is deliberately absent: the server always derives the cart
/// item's price from `Subject.bundlePrice` server-side and ignores/rejects
/// a client-supplied price (`MOBILE_CHANGES.md` §2). Separate from
/// `CartItemDto`, which models the richer response shape instead.
@freezed
abstract class AddCartItemRequestDto with _$AddCartItemRequestDto {
  const factory AddCartItemRequestDto({
    required String subjectId,
    @NullableDecimalStringConverter() double? discountedPrice,
  }) = _AddCartItemRequestDto;

  factory AddCartItemRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemRequestDtoFromJson(json);
}
