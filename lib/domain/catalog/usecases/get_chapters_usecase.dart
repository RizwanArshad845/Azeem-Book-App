import '../../common/result.dart';
import '../entities/chapter.dart';
import '../repositories/catalog_repository.dart';

/// Fetches ordered chapters belonging to a single `subjectId`.
class GetChaptersUseCase {
  const GetChaptersUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<List<Chapter>>> call(String subjectId) =>
      _repository.getChapters(subjectId);
}
