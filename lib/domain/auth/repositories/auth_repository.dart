import '../../common/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_role.dart';

/// Zero Flutter/Riverpod/package dependencies per §2 Clean Architecture
/// rules. Auth is passwordless — Google Sign-In only — for Teacher and
/// Student roles.
abstract class AuthRepository {
  /// Shows Google's account picker, then exchanges the account's ID token
  /// with the backend for a session acting as [role]. On success returns a
  /// fully populated [AuthSession] (non-null `token`), already persisted.
  /// Returns `null` inside the [Result] if the user dismissed the picker.
  Future<Result<AuthSession?>> signInWithGoogle(UserRole role);

  /// Asks the backend for the current routing status
  /// (`GET /auth/session-status`) and, when one comes back, persists it onto
  /// the stored session so a restart doesn't resurrect a stale status.
  Future<Result<String?>> refreshSessionStatus();

  /// Clears the current session (interceptor token + persisted storage) and
  /// forgets the Google account so the next login shows the picker again.
  Future<Result<void>> logout();

  /// Reads the session that was persisted to secure storage on the last
  /// successful sign-in. Returns `null` inside the [Result] if no session is
  /// stored (first install, after logout, or a pre-Google-Sign-In session).
  /// Also restores [AuthInterceptor.currentToken] so subsequent API calls are
  /// authenticated.
  Future<Result<AuthSession?>> getStoredSession();
}
