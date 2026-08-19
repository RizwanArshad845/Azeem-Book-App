import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'cart.freezed.dart';

/// A student's shopping cart of tests-to-purchase (project_spec.md §9.2
/// `Cart`). `totalAmount` is the sum of each item's
/// `discountedPrice ?? price` — kept as a stored field (not a getter) to
/// mirror the schema exactly; callers that mutate `items` are responsible
/// for recomputing it (done by `CartRepository`, never by the UI layer).
@freezed
abstract class Cart with _$Cart {
  const factory Cart({
    required String id,
    required String studentId,
    List<CartItem>? items,
    @Default(0) double totalAmount,
  }) = _Cart;
}
