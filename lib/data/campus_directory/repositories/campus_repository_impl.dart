import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/campus_directory/repositories/campus_repository.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../datasources/remote/campus_remote_datasource.dart';

class CampusRepositoryImpl implements CampusRepository {
  CampusRepositoryImpl({required this.remote});

  final CampusRemoteDataSource remote;

  @override
  Future<Result<List<Campus>>> getCampuses() async {
    try {
      final dtos = await remote.getCampuses();
      return Success(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
