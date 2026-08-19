import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../../earnings/usecases/record_earnings_usecase.dart';
import '../../student_onboarding/entities/subject_enrollment.dart';
import '../entities/cart_item.dart';
import '../entities/payment.dart';
import '../repositories/cart_repository.dart';

/// Simulates a payment-gateway checkout of the student's current cart
/// (§10.2 "checkout -> payment gateway redirect").
///
/// Also owns the teacher-commission attribution trigger (project_spec.md
/// §9.1: "Triggered when a student completes a paid-pack purchase;
/// attributes a commission to the `teacherId` ... associated with that
/// subject/enrollment", §9.2 `EarningsRecord`). This lives here rather than
/// inside `CartRepository`/`earnings` because it is a cross-feature side
/// effect of checkout succeeding, not part of the cart's own persistence —
/// matching how `CartRepository.addItem` already takes `Test`/
/// `SubjectEnrollment` entities from its caller instead of reaching into
/// other repositories itself.
///
/// [cartItems]/[testsById]/[subjectEnrollments] must reflect the cart
/// *before* checkout clears it — the caller (viewmodel) reads its own
/// already-resolved `Cart` state and the `Test`/`SubjectEnrollment` data it
/// already has (mirrors `StudentCartViewModel.addTest`'s use of
/// `studentOnboardingViewModelProvider`) and passes them straight through,
/// so this use case never needs a `CatalogRepository`/`StudentRepository`
/// dependency of its own.
class CheckoutUseCase {
  const CheckoutUseCase(this._repository, this._recordEarnings);

  final CartRepository _repository;
  final RecordEarningsUseCase _recordEarnings;

  /// Flat commission rate applied to each purchased item's paid price
  /// (`discountedPrice ?? price`) when that item's subject has a teacher
  /// attached via `SubjectEnrollment.teacherId`. Arbitrary but consistent
  /// demo rate — §9.2 doesn't specify one — mirrors
  /// `CartRepositoryImpl._teacherDiscountMultiplier`'s "documented, not
  /// invented" approach.
  static const _teacherCommissionRate = 0.10;

  Future<Result<Payment>> call(
    String studentId, {
    required List<CartItem> cartItems,
    required Map<String, Test> testsById,
    required List<SubjectEnrollment> subjectEnrollments,
  }) async {
    final result = await _repository.checkout(studentId);

    if (result is Success<Payment> && result.data.status == PaymentStatus.success) {
      await _attributeEarnings(
        studentId: studentId,
        cartItems: cartItems,
        testsById: testsById,
        subjectEnrollments: subjectEnrollments,
      );
    }

    return result;
  }

  /// One `EarningsRecord` per checked-out item whose subject has a teacher
  /// attached (§9.2 `SubjectEnrollment.teacherId`) — not one per whole
  /// checkout — so the Teacher Earnings tab's transaction list (§10.2) can
  /// show a distinct line per commission-earning purchase. Best-effort: a
  /// failure recording one item's commission does not fail the others or
  /// the checkout itself (the payment already succeeded).
  Future<void> _attributeEarnings({
    required String studentId,
    required List<CartItem> cartItems,
    required Map<String, Test> testsById,
    required List<SubjectEnrollment> subjectEnrollments,
  }) async {
    for (final item in cartItems) {
      final test = testsById[item.testId];
      if (test == null) continue;

      String? teacherId;
      for (final enrollment in subjectEnrollments) {
        if (enrollment.subjectId == test.subjectId &&
            enrollment.teacherId != null) {
          teacherId = enrollment.teacherId;
          break;
        }
      }
      if (teacherId == null) continue;

      final paidPrice = item.discountedPrice ?? item.price;
      await _recordEarnings(
        studentId: studentId,
        amount: paidPrice * _teacherCommissionRate,
        teacherId: teacherId,
      );
    }
  }
}
