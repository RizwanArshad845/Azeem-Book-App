import '../../../core/config/app_config.dart';
import '../../../domain/common/result.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../../domain/earnings/repositories/earnings_repository.dart';
import '../datasources/local/earnings_dummy_datasource.dart';
import '../datasources/remote/earnings_remote_datasource.dart';
import '../models/earnings_record_dto.dart';

/// Switches between [EarningsRemoteDataSource] and [EarningsDummyDataSource]
/// based on `AppConfig.isMockMode` (project_spec.md §6.2) and maps DTOs to
/// domain entities so nothing above this layer ever sees a DTO — mirrors
/// `CartRepositoryImpl`/`LiveTestRegistrationRepositoryImpl`.
class EarningsRepositoryImpl implements EarningsRepository {
  EarningsRepositoryImpl({
    required this.remote,
    required this.dummy,
    this.isMockMode = AppConfig.isMockMode,
  });

  final EarningsRemoteDataSource remote;
  final EarningsDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<EarningsRecord>> recordEarnings({
    required String studentId,
    required double amount,
    String? teacherId,
    String? salesmanId,
  }) async {
    final draft = EarningsRecordDto(
      id: '',
      teacherId: teacherId,
      salesmanId: salesmanId,
      studentId: studentId,
      amount: amount,
      triggerEvent: EarningsTriggerEvent.paidPackPurchase,
      createdAt: DateTime.now(),
    );
    final result = isMockMode
        ? await dummy.recordEarnings(draft)
        : await remote.recordEarnings(draft);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<EarningsRecord>>> getEarningsForTeacher(
    String teacherId,
  ) async {
    final result = isMockMode
        ? await dummy.getEarningsForTeacher(teacherId)
        : await remote.getEarningsForTeacher(teacherId);
    return result.when(
      success: (dtos) => Success(dtos.map((dto) => dto.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
