import '../../common/result.dart';
import '../entities/ebook.dart';
import '../repositories/catalog_repository.dart';

/// Fetches ebook conversion status + page count for a single `subjectId`.
class GetEbookUseCase {
  const GetEbookUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<Ebook>> call(String subjectId) =>
      _repository.getEbook(subjectId);
}
