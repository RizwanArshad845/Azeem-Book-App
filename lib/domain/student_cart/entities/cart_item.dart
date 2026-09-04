import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

/// A single line item inside a [Cart] (project_spec.md §9.2 `CartItem`).
///
/// Bundle-only purchasing (user decision, see project_spec.md §9.2 prose):
/// a student buys a whole [subjectId], not individual tests — including
/// tests Admin adds to that subject *after* the purchase. `subjectName`/
/// `testCount` are denormalized at add-time purely for cart display
/// (`testCount` tests included when the bundle was added).
///
/// `price`/`discountedPrice` are the only place a subject bundle's price
/// lives in this schema (`Test` itself has no price field, §9.2) — see
/// `price_for_test.dart`/`price_for_subject_bundle.dart` for why and how a
/// price is assigned at add-to-cart time.
///
/// The real backend's cart-item response doesn't echo back `subjectName`/
/// `testCount` (`FRONTEND_INTEGRATION.md` §6.5: `{id, subjectId, price,
/// discountedPrice}` only) — nullable here, resolve for display from the
/// catalog subjects list keyed by `subjectId` when null, same pattern as
/// `teacher_profile_view.dart`'s `subjectsById[id]?.name ?? id`.
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    String? id,
    required String subjectId,
    String? subjectName,
    int? testCount,
    required double price,
    double? discountedPrice,
  }) = _CartItem;
}
