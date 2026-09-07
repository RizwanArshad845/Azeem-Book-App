import '../../catalog/entities/subject.dart';
import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../entities/cart.dart';
import '../entities/payment.dart';

/// Per-student cart + checkout access (project_spec.md §9.2 `Cart`,
/// `CartItem`, `Payment`; §10.2 Cart tab).
///
/// Concrete implementation calls the remote datasource directly — never
/// called directly from a viewmodel.
///
/// [addSubjectBundle] takes a [Subject] directly rather than just a
/// `subjectId` purely so [tests]'s bundle-purchase caller can report the
/// bundle's name/test count for display caching — pricing and discount are
/// both fully server-computed from `Subject.bundlePrice` and the student's
/// teacher enrollment (`MOBILE_CHANGES.md` §2–3), the client has no input
/// into either.
abstract class CartRepository {
  /// Returns the student's cart, creating an empty one on first access.
  Future<Result<Cart>> getCart(String studentId, {bool forceRefresh = false});

  /// Adds a whole-[subject] bundle (all of [tests], purchased together — see
  /// `CartItem` doc comment for why bundle-only) to [studentId]'s cart.
  /// No-ops (returns the cart unchanged) if the subject is already present.
  /// `CartItem.price`/`discountedPrice` are both set server-side.
  Future<Result<Cart>> addSubjectBundle(
    String studentId,
    Subject subject,
    List<Test> tests,
  );

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
