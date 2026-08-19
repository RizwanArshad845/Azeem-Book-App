import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

/// `status` of a [Payment] (project_spec.md §9.2).
enum PaymentStatus { pending, success, failed }

/// Result of a checkout attempt against the (simulated, in dummy mode)
/// payment gateway (project_spec.md §9.2 `Payment`, §10.2 "checkout ->
/// payment gateway redirect"). A `success` status is what makes every
/// `testId` in the checked-out cart "purchased" for that student — see
/// `GetPurchasedTestIdsUseCase`.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String studentId,
    required double amount,
    required PaymentStatus status,
    String? gatewayReference,
    required DateTime createdAt,
  }) = _Payment;
}
