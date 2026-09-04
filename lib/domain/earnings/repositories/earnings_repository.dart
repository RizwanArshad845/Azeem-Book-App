import '../../common/result.dart';
import '../entities/earnings_record.dart';

/// Commission-record access (project_spec.md §9.2 `EarningsRecord`; §9.1
/// "triggered when a student completes a paid-pack purchase").
///
/// Read-only: the real backend has no write endpoint for this resource —
/// `EarningsRecord`s are created server-side automatically when `POST
/// /cart/checkout` succeeds (`FRONTEND_INTEGRATION.md` §6.5/§8
/// `earningsCredited`), not via a client-facing POST.
abstract class EarningsRepository {
  /// Every `EarningsRecord` attributed to [teacherId], newest first — backs
  /// the Teacher Earnings tab (§10.2 "Detailed Earnings Dashboard").
  Future<Result<List<EarningsRecord>>> getEarningsForTeacher(
    String teacherId,
  );
}
