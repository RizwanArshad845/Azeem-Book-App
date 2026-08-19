import '../../common/result.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Removes a single test from the student's cart.
class RemoveFromCartUseCase {
  const RemoveFromCartUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Cart>> call(String studentId, String testId) =>
      _repository.removeItem(studentId, testId);
}
