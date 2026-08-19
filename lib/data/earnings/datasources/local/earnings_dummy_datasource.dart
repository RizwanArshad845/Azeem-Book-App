import '../../../../domain/common/result.dart';
import '../../models/earnings_record_dto.dart';

/// Same method signatures as [EarningsRemoteDataSource] so the repository
/// can swap between the two based purely on `AppConfig.isMockMode` (§6.2),
/// matching `CartDummyDataSource`'s pattern.
abstract class EarningsDummyDataSource {
  Future<Result<EarningsRecordDto>> recordEarnings(EarningsRecordDto draft);

  Future<Result<List<EarningsRecordDto>>> getEarningsForTeacher(
    String teacherId,
  );
}

/// In-memory commission ledger shared across the whole app session.
/// `recordEarnings` assigns the id (ignoring whatever the caller passed in
/// `draft.id`) so `EarningsRepositoryImpl` never has to invent one either —
/// mirrors `CartDummyDataSourceImpl`'s counter-based id scheme.
class EarningsDummyDataSourceImpl implements EarningsDummyDataSource {
  static const _latency = Duration(milliseconds: 400);

  final List<EarningsRecordDto> _records = [];

  int _counter = 0;

  @override
  Future<Result<EarningsRecordDto>> recordEarnings(
    EarningsRecordDto draft,
  ) async {
    await Future.delayed(_latency);
    _counter++;
    final record = draft.copyWith(id: 'earnings-$_counter');
    _records.add(record);
    return Success(record);
  }

  @override
  Future<Result<List<EarningsRecordDto>>> getEarningsForTeacher(
    String teacherId,
  ) async {
    await Future.delayed(_latency);
    final records = _records.where((r) => r.teacherId == teacherId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Success(List.unmodifiable(records));
  }
}
