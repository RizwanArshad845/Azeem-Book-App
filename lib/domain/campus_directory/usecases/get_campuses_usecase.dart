import '../../common/result.dart';
import '../entities/campus.dart';
import '../repositories/campus_repository.dart';

/// Single-purpose use case returning the full campus directory.
class GetCampusesUseCase {
  const GetCampusesUseCase(this._repository);

  final CampusRepository _repository;

  Future<Result<List<Campus>>> call() => _repository.getCampuses();
}
