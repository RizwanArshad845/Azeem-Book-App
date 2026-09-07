import '../../catalog/entities/subject.dart';
import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../../student_onboarding/entities/subject_enrollment.dart';
import '../entities/cart.dart';
import '../entities/payment.dart';

/// Per-student cart + checkout access (project_spec.md §9.2 `Cart`,
/// `CartItem`, `Payment`; §10.2 Cart tab).
///
/// Concrete implementation calls the remote datasource directly — never
/// called directly from a viewmodel.
///
/// [addSubjectBundle] takes a [Subject] (and the student's current
/// [SubjectEnrollment]s) directly rather than just a `subjectId`: pricing
/// comes from `Subject.bundlePrice` (the server's authoritative price —
/// the server derives the cart item's actual price from it independently,
/// this is only used to compute the discounted price sent alongside it),
/// and the discount depends on the student's teacher-discount eligibility
/// for that subject. Passing the entity in keeps this repository free of a
/// cross-feature dependency on the catalog/student_onboarding
/// *repositories* — the caller (viewmodel, which already has it via an
/// existing provider) supplies it. [tests] is still required to report the
/// bundle's test count for display.
abstract class CartRepository {
  /// Returns the student's cart, creating an empty one on first access.
  Future<Result<Cart>> getCart(String studentId, {bool forceRefresh = false});

  /// Adds a whole-[subject] bundle (all of [tests], purchased together — see
  /// `CartItem` doc comment for why bundle-only) to [studentId]'s cart.
  /// No-ops (returns the cart unchanged) if the subject is already present.
  /// `CartItem.price` is set server-side from `Subject.bundlePrice`;
  /// `CartItem.discountedPrice` is computed here off `subject.bundlePrice`
  /// per the teacher-discount rule: 20% off when [subjectEnrollments]
  /// contains a `SubjectEnrollment` for `subject.id` with
  /// `discountApplied == true`.
  Future<Result<Cart>> addSubjectBundle(
    String studentId,
    Subject subject,
    List<Test> tests, {
    required List<SubjectEnrollment> subjectEnrollments,
  });

  Future<Result<Cart>> removeItem(String studentId, String subjectId);

  /// Simulates a payment-gateway checkout for the student's current cart.
  /// On success: clears the cart's items, and every `subjectId` that was in
  /// it becomes "purchased" for that student (see [getPurchasedSubjectIds]).
  Future<Result<Payment>> checkout(String studentId);

  /// Every `subjectId` that has ever appeared in a `success`-status
  /// [Payment] for [studentId]. Drives the `test-taking` feature's purchase
  /// gate: a student may attempt a test if it's `Test.isFreeSample` or its
  /// `subjectId` is in this set — subject-scoped rather than test-scoped so
  /// a test Admin adds to an already-purchased subject is unlocked too.
  Future<Result<Set<String>>> getPurchasedSubjectIds(
    String studentId, {
    bool forceRefresh = false,
  });

  void clearCache();
}
