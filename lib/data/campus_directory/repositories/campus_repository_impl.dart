import '../../../core/network/result_guard.dart';
import '../../../core/storage/local_cache_service.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/campus_directory/repositories/campus_repository.dart';
import '../../../domain/common/result.dart';
import '../../common/swr_repository_mixin.dart';
import '../datasources/remote/campus_remote_datasource.dart';
import '../models/campus_dto.dart';

class CampusRepositoryImpl with SwrRepositoryMixin implements CampusRepository {
  CampusRepositoryImpl({
    required this.remote,
    required this.cache,
  });

  final CampusRemoteDataSource remote;

  @override
  final LocalCacheService cache;

  List<Campus>? _cachedCampuses;
  static const _cacheKey = 'cached_campuses';

  @override
  Future<Result<List<Campus>>> getCampuses({bool forceRefresh = false}) {
    return fetchListWithSwr<Campus>(
      cacheKey: _cacheKey,
      fromJson: (json) => CampusDto.fromJson(json).toDomain(),
      toJson: (campus) => CampusDto.fromDomain(campus).toJson(),
      fetchRemote: () => guardRequest(() async {
        final dtos = await remote.getCampuses();
        return dtos.map((dto) => dto.toDomain()).toList();
      }),
      getMemory: () => _cachedCampuses,
      setMemory: (value) => _cachedCampuses = value,
      forceRefresh: forceRefresh,
    );
  }

  @override
  void clearCache() {
    _cachedCampuses = null;
    cache.remove(_cacheKey);
  }
}
