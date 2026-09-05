import '../../../core/network/result_guard.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/campus_directory/repositories/campus_repository.dart';
import '../../../domain/common/result.dart';
import '../datasources/remote/campus_remote_datasource.dart';

class CampusRepositoryImpl implements CampusRepository {
  CampusRepositoryImpl({required this.remote});

  final CampusRemoteDataSource remote;

  List<Campus>? _cachedCampuses;

  @override
  Future<Result<List<Campus>>> getCampuses({bool forceRefresh = false}) async {
    if (_cachedCampuses != null && !forceRefresh) {
      return Success(_cachedCampuses!);
    }
    final result = await guardRequest(() async {
      final dtos = await remote.getCampuses();
      return dtos.map((dto) => dto.toDomain()).toList();
    });
    return result.when(
      success: (campuses) {
        _cachedCampuses = campuses;
        return Success(campuses);
      },
      failure: (f) {
        final cached = _cachedCampuses;
        return cached != null ? Success(cached) : ResultFailure(f);
      },
    );
  }

  @override
  void clearCache() {
    _cachedCampuses = null;
  }
}
