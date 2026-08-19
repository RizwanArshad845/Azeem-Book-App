import '../../common/result.dart';
import '../entities/earnings_record.dart';
import '../repositories/earnings_repository.dart';

/// Records a single commission attribution. Single-purpose use case per
/// CLAUDE.md §1 — called from `CheckoutUseCase` right after a successful
/// payment, once per cart item that resolved to a teacher-attributed
/// subject (see `CheckoutUseCase` doc comment for the full attribution
/// rule).
class RecordEarningsUseCase {
  const RecordEarningsUseCase(this._repository);

  final EarningsRepository _repository;

  Future<Result<EarningsRecord>> call({
    required String studentId,
    required double amount,
    String? teacherId,
    String? salesmanId,
  }) => _repository.recordEarnings(
    studentId: studentId,
    amount: amount,
    teacherId: teacherId,
    salesmanId: salesmanId,
  );
}
