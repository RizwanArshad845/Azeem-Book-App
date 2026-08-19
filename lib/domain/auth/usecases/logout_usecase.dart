import '../../common/result.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: clear the current session.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
