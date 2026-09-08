import '../../common/result.dart';
import '../entities/subject.dart';
import '../repositories/catalog_repository.dart';

/// Fetches subjects scoped to a single `boardClassId`.
class GetSubjectsUseCase {
  const GetSubjectsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<List<Subject>>> call(
    String boardClassId, {
    bool forceRefresh = false,
  }) =>
      _repository.getSubjects(boardClassId, forceRefresh: forceRefresh);
}
