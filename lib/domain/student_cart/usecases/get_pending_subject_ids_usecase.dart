import '../../common/result.dart';
import '../repositories/cart_repository.dart';

/// Every `subjectId` tied up in a gateway payment the backend hasn't had an
/// outcome for yet — shown as "payment processing" instead of buyable, and
/// what `PaymentConfirmationViewModel` resumes waiting on after a restart.
class GetPendingSubjectIdsUseCase {
  const GetPendingSubjectIdsUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Set<String>>> call(
    String studentId, {
    bool forceRefresh = false,
  }) =>
      _repository.getPendingSubjectIds(
        studentId,
        forceRefresh: forceRefresh,
      );
}
