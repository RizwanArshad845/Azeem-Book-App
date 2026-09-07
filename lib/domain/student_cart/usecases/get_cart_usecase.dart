import '../../common/result.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Fetches (or lazily creates) the current student's cart.
class GetCartUseCase {
  const GetCartUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Cart>> call(String studentId, {bool forceRefresh = false}) =>
      _repository.getCart(studentId, forceRefresh: forceRefresh);
}
