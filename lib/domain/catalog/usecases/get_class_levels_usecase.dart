import '../../common/result.dart';
import '../entities/class_level.dart';
import '../repositories/catalog_repository.dart';

/// Fetches every Admin-authored class level row (enabled and disabled).
class GetClassLevelsUseCase {
  const GetClassLevelsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<List<ClassLevel>>> call() => _repository.getClassLevels();
}
