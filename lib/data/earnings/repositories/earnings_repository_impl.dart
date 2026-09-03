import '../../../domain/common/result.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../../domain/earnings/repositories/earnings_repository.dart';
import '../datasources/remote/earnings_remote_datasource.dart';
import '../models/earnings_record_dto.dart';

/// Maps [EarningsRemoteDataSource] DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
class EarningsRepositoryImpl implements EarningsRepository {
  EarningsRepositoryImpl({required this.remote});

  final EarningsRemoteDataSource remote;

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
    final result = await remote.recordEarnings(draft);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<EarningsRecord>>> getEarningsForTeacher(
    String teacherId,
  ) async {
    final result = await remote.getEarningsForTeacher(teacherId);
    return result.when(
      success: (dtos) => Success(dtos.map((dto) => dto.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
