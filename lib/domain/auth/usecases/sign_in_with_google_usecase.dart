import '../../common/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: sign in with Google acting as [role], producing a
/// session on success. A `null` session means the user dismissed the Google
/// account picker — not an error.
class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession?>> call(UserRole role) =>
      _repository.signInWithGoogle(role);
}
