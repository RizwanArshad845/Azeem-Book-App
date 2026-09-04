import '../../../domain/common/result.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../../domain/earnings/repositories/earnings_repository.dart';
import '../datasources/remote/earnings_remote_datasource.dart';

/// Maps [EarningsRemoteDataSource] DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
class EarningsRepositoryImpl implements EarningsRepository {
  EarningsRepositoryImpl({required this.remote});

  final EarningsRemoteDataSource remote;

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
