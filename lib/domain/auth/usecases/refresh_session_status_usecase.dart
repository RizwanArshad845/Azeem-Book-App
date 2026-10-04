import '../../common/result.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: re-fetch the routing status for the current
/// session (`GET /auth/session-status`) — e.g. a pending teacher checking
/// whether an admin has approved them yet.
class RefreshSessionStatusUseCase {
  const RefreshSessionStatusUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<String?>> call() => _repository.refreshSessionStatus();
}
