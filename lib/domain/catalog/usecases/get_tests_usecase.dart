import '../../common/result.dart';
import '../entities/test.dart';
import '../repositories/catalog_repository.dart';

/// Fetches tests scoped to a subject and/or a chapter.
class GetTestsUseCase {
  const GetTestsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<List<Test>>> call({String? subjectId, String? chapterId}) =>
      _repository.getTests(subjectId: subjectId, chapterId: chapterId);
}
