import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

/// A single line item inside a [Cart] (project_spec.md §9.2 `CartItem`).
///
/// `price`/`discountedPrice` are the only place a `Test`'s price lives in
/// this schema (`Test` itself has no price field, §9.2) — see
/// `price_for_test.dart` for why and how a price is assigned at
/// add-to-cart time.
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String testId,
    required double price,
    double? discountedPrice,
  }) = _CartItem;
}
