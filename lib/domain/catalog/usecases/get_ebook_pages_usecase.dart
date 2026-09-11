import '../../common/result.dart';
import '../entities/ebook_page.dart';
import '../repositories/catalog_repository.dart';

/// Fetches one window of signed ebook page-image URLs for a `subjectId`.
class GetEbookPagesUseCase {
  const GetEbookPagesUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<EbookPageWindow>> call(
    String subjectId, {
    int startPage = 1,
    int count = 20,
  }) => _repository.getEbookPages(
    subjectId,
    startPage: startPage,
    count: count,
  );
}
