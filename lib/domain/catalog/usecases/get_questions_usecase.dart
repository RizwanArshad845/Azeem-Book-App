import '../../common/result.dart';
import '../entities/question.dart';
import '../repositories/catalog_repository.dart';

/// Fetches the structured questions that make up a single test.
class GetQuestionsUseCase {
  const GetQuestionsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<List<Question>>> call(String testId) =>
      _repository.getQuestions(testId);
}
