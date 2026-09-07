import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_cart_item_request_dto.freezed.dart';
part 'add_cart_item_request_dto.g.dart';

/// Outgoing add-to-cart request body — mirrors the backend's
/// `CartItemInputSerializer` exactly (`subjectId` is the only field it
/// accepts). Both `price` and `discountedPrice` are deliberately absent:
/// the server always derives the cart item's price from `Subject.bundlePrice`
/// and auto-computes the discount from the student's teacher enrollment,
/// ignoring any client-supplied value for either (`MOBILE_CHANGES.md` §3).
/// Separate from `CartItemDto`, which models the richer response shape
/// instead.
@freezed
abstract class AddCartItemRequestDto with _$AddCartItemRequestDto {
  const factory AddCartItemRequestDto({required String subjectId}) =
      _AddCartItemRequestDto;

  factory AddCartItemRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemRequestDtoFromJson(json);
}
