import 'package:freezed_annotation/freezed_annotation.dart';

/// The real backend serializes every decimal field (`actualEarnings`,
/// `amount`, `price`, `totalAmount`, etc.) as a JSON **string** rather than a
/// number (`FRONTEND_INTEGRATION.md` §3) — Django's `DecimalField` via DRF.
/// Accepts a plain number too, since request bodies are allowed to send
/// either (§6.5 cart endpoints: `"decimal-string-or-number"`).
class DecimalStringConverter implements JsonConverter<double, Object?> {
  const DecimalStringConverter();

  @override
  double fromJson(Object? json) {
    if (json is num) return json.toDouble();
    if (json is String) return double.parse(json);
    throw FormatException('Cannot convert $json to double');
  }

  @override
  Object toJson(double object) => object;
}

/// Nullable counterpart of [DecimalStringConverter] for optional decimal
/// fields (e.g. `projectedEarnings`, `discountedPrice`).
class NullableDecimalStringConverter implements JsonConverter<double?, Object?> {
  const NullableDecimalStringConverter();

  @override
  double? fromJson(Object? json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    if (json is String) return double.parse(json);
    throw FormatException('Cannot convert $json to double');
  }

  @override
  Object? toJson(double? object) => object;
}
