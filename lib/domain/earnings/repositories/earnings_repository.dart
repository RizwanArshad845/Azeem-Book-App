import '../../common/result.dart';
import '../entities/earnings_record.dart';

/// Commission-record access (project_spec.md §9.2 `EarningsRecord`; §9.1
/// "triggered when a student completes a paid-pack purchase").
///
/// Concrete implementation calls the remote datasource directly — never
/// called directly from a viewmodel.
abstract class EarningsRepository {
  /// Persists a new commission record with `triggerEvent ==
  /// EarningsTriggerEvent.paidPackPurchase` and `createdAt == now`. Called
  /// from `student_cart`'s checkout flow (via `RecordEarningsUseCase`)
  /// immediately after a successful payment — never from this feature's own
  /// presentation layer, which is read-only.
  Future<Result<EarningsRecord>> recordEarnings({
    required String studentId,
    required double amount,
    String? teacherId,
    String? salesmanId,
  });

  /// Every `EarningsRecord` attributed to [teacherId], newest first — backs
  /// the Teacher Earnings tab (§10.2 "Detailed Earnings Dashboard").
  Future<Result<List<EarningsRecord>>> getEarningsForTeacher(
    String teacherId,
  );
}
