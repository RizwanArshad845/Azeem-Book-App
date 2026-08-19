import '../../common/result.dart';
import '../repositories/cart_repository.dart';

/// Every `subjectId` that has ever appeared in a `success`-status `Payment`
/// for [studentId]. First-class, permanent part of this feature's public
/// surface: the `test-taking` feature depends on it directly to decide
/// whether a student may attempt a given test (either it's
/// `Test.isFreeSample`, or its `subjectId` is in this set).
class GetPurchasedSubjectIdsUseCase {
  const GetPurchasedSubjectIdsUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Set<String>>> call(String studentId) =>
      _repository.getPurchasedSubjectIds(studentId);
}
