import '../../../../domain/common/result.dart';
import '../../../../domain/earnings/entities/earnings_record.dart';
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

/// In-memory commission ledger shared across the whole app session, seeded with
/// initial earnings for the 11 paid student bundle purchases.
class EarningsDummyDataSourceImpl implements EarningsDummyDataSource {
  EarningsDummyDataSourceImpl() {
    _seedInitialEarnings();
  }

  static const _latency = Duration(milliseconds: 400);

  final List<EarningsRecordDto> _records = [];

  int _counter = 0;

  void _seedInitialEarnings() {
    final now = DateTime.now();
    final paidStudentIds = [
      ('student-001', 20),
      ('student-002', 18),
      ('student-003', 16),
      ('student-004', 15),
      ('student-005', 14),
      ('student-006', 12),
      ('student-007', 10),
      ('student-008', 8),
      ('student-009', 7),
      ('student-010', 5),
      ('student-011', 4),
    ];

    for (final (studentId, daysAgo) in paidStudentIds) {
      _counter++;
      _records.add(
        EarningsRecordDto(
          id: 'earnings-$_counter',
          teacherId: 'teacher-mock',
          studentId: studentId,
          amount: 500.0,
          triggerEvent: EarningsTriggerEvent.paidPackPurchase,
          createdAt: now.subtract(Duration(days: daysAgo)),
        ),
      );
    }
  }

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
    // Dynamically bind to the current teacher ID so mock earnings are visible
    final records = _records.map((r) => r.copyWith(teacherId: teacherId)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Success(List.unmodifiable(records));
  }
}
