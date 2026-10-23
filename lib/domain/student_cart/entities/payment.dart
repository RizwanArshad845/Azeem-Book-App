import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

/// `status` of a [Payment] (project_spec.md §9.2).
enum PaymentStatus { pending, success, failed }

/// Result of a checkout attempt against the RapidGateway hosted checkout
/// (project_spec.md §9.2 `Payment`, §10.2 "checkout -> payment gateway
/// redirect"). A real checkout comes back `pending` with a [checkoutUrl] the
/// student pays on; only the backend's signed webhook moves it to `success`,
/// which is what makes every subject in the checked-out cart "purchased" —
/// see `GetPurchasedSubjectIdsUseCase`. A free cart settles immediately
/// (`success`, no [checkoutUrl]).
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String studentId,
    required double amount,
    required PaymentStatus status,
    String? gatewayReference,
    String? checkoutUrl,
    required DateTime createdAt,
  }) = _Payment;
}
