import '../../common/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Reads the [AuthSession] that was persisted to secure storage on the last
/// successful OTP verify, and re-stamps [AuthInterceptor.currentToken] so
/// that all subsequent API calls include a valid Bearer token without
/// requiring a new OTP round-trip.
///
/// Returns `null` inside the [Result] on first install or after logout.
/// Called once from [AuthViewModel.build] so the token is always restored
/// before any provider downstream of [currentUserProvider] runs.
class GetStoredSessionUseCase {
  const GetStoredSessionUseCase(this._repo);

  final AuthRepository _repo;

  Future<Result<AuthSession?>> call() => _repo.getStoredSession();
}
