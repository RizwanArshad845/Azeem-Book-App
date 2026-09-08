import '../../../core/storage/local_cache_service.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../../domain/earnings/repositories/earnings_repository.dart';
import '../../common/swr_repository_mixin.dart';
import '../datasources/remote/earnings_remote_datasource.dart';
import '../models/earnings_record_dto.dart';

/// Maps [EarningsRemoteDataSource] DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
class EarningsRepositoryImpl
    with SwrRepositoryMixin
    implements EarningsRepository {
  EarningsRepositoryImpl({required this.remote, required this.cache});

  final EarningsRemoteDataSource remote;

  @override
  final LocalCacheService cache;

  final Map<String, List<EarningsRecord>> _cachedEarningsByTeacher = {};

  @override
  Future<Result<List<EarningsRecord>>> getEarningsForTeacher(
    String teacherId,
  ) {
    return fetchListWithSwr<EarningsRecord>(
      cacheKey: 'cached_earnings_teacher_$teacherId',
      fromJson: (json) => EarningsRecordDto.fromJson(json).toDomain(),
      toJson: (record) => EarningsRecordDto.fromDomain(record).toJson(),
      // Earnings are credited async by the backend on checkout events, so
      // this is the most "live" of the SWR-cached repos — still worth a
      // short cache for switching Overview<->Earnings within one session.
      ttl: const Duration(minutes: 10),
      fetchRemote: () async {
        final result = await remote.getEarningsForTeacher(teacherId);
        return result.when(
          success: (dtos) =>
              Success(dtos.map((dto) => dto.toDomain()).toList()),
          failure: (f) => f is NotFoundFailure
              ? const Success(<EarningsRecord>[])
              : ResultFailure(f),
        );
      },
      getMemory: () => _cachedEarningsByTeacher[teacherId],
      setMemory: (value) => _cachedEarningsByTeacher[teacherId] = value,
    );
  }
}
