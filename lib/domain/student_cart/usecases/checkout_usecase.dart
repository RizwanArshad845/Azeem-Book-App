import '../../common/result.dart';
import '../entities/payment.dart';
import '../repositories/cart_repository.dart';

/// Checks out the student's current cart (§10.2 "checkout -> payment
/// gateway redirect").
///
/// Teacher-commission attribution (project_spec.md §9.1 `EarningsRecord`)
/// is **not** done client-side — the real backend derives it automatically
/// from `SubjectEnrollment.teacherId` when `POST /cart/checkout` succeeds
/// (`FRONTEND_INTEGRATION.md` §6.5/§8 `earningsCredited`). There is no
/// client-facing write endpoint for `EarningsRecord` to call here.
class CheckoutUseCase {
  const CheckoutUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Payment>> call(String studentId) =>
      _repository.checkout(studentId);
}
