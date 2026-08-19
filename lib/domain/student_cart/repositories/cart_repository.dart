import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../../student_onboarding/entities/subject_enrollment.dart';
import '../entities/cart.dart';
import '../entities/payment.dart';

/// Per-student cart + checkout access (project_spec.md §9.2 `Cart`,
/// `CartItem`, `Payment`; §10.2 Cart tab).
///
/// Concrete implementation picks a dummy or remote datasource based on
/// `AppConfig.isMockMode` (§6.2) — never called directly from a viewmodel.
///
/// [addItem] takes a [Test] (and the student's current
/// [SubjectEnrollment]s) directly rather than just a `testId`, because
/// §9.2's `Test` entity has no price field — pricing/discount must be
/// computed here from the `Test` itself (see `price_for_test.dart`) and the
/// student's teacher-discount eligibility for that test's subject. Passing
/// both in keeps this repository free of a cross-feature dependency on the
/// catalog/student_onboarding *repositories* — the caller (viewmodel, which
/// already has both via existing providers) supplies the entities.
abstract class CartRepository {
  /// Returns the student's cart, creating an empty one on first access.
  Future<Result<Cart>> getCart(String studentId);

  /// Adds [test] to [studentId]'s cart. No-ops (returns the cart unchanged)
  /// if the test is already present. Computes `CartItem.price` via
  /// `priceForTest(test)` and `CartItem.discountedPrice` per the
  /// teacher-discount rule: 20% off when [subjectEnrollments] contains a
  /// `SubjectEnrollment` for `test.subjectId` with `discountApplied == true`.
  Future<Result<Cart>> addItem(
    String studentId,
    Test test, {
    required List<SubjectEnrollment> subjectEnrollments,
  });

  Future<Result<Cart>> removeItem(String studentId, String testId);

  /// Simulates a payment-gateway checkout for the student's current cart.
  /// On success: clears the cart's items, and every `testId` that was in it
  /// becomes "purchased" for that student (see [getPurchasedTestIds]).
  Future<Result<Payment>> checkout(String studentId);

  /// Every `testId` that has ever appeared in a `success`-status [Payment]
  /// for [studentId]. Drives the `test-taking` feature's purchase gate: a
  /// student may attempt a test if it's `Test.isFreeSample` or its id is in
  /// this set.
  Future<Result<Set<String>>> getPurchasedTestIds(String studentId);
}
