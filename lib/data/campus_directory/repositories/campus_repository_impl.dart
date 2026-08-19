import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/campus_directory/repositories/campus_repository.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../datasources/local/campus_dummy_datasource.dart';
import '../datasources/remote/campus_remote_datasource.dart';

/// Switches between the dummy and remote datasource per `AppConfig.isMockMode`
/// (§6.1/§6.2) — never called with a live endpoint directly from a viewmodel.
class CampusRepositoryImpl implements CampusRepository {
  CampusRepositoryImpl({
    required this.remote,
    required this.dummy,
    required this.isMockMode,
  });

  final CampusRemoteDataSource remote;
  final CampusDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<List<Campus>>> getCampuses() async {
    try {
      final dtos = isMockMode
          ? await dummy.getCampuses()
          : await remote.getCampuses();
      return Success(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
