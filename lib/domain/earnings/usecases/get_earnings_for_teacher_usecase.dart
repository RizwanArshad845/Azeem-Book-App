import '../../common/result.dart';
import '../entities/earnings_record.dart';
import '../repositories/earnings_repository.dart';

/// Every `EarningsRecord` attributed to a teacher — backs the Teacher
/// Earnings tab's transaction list (§10.2).
class GetEarningsForTeacherUseCase {
  const GetEarningsForTeacherUseCase(this._repository);

  final EarningsRepository _repository;

  Future<Result<List<EarningsRecord>>> call(String teacherId) =>
      _repository.getEarningsForTeacher(teacherId);
}
