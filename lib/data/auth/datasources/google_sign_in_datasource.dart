import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/app_config.dart';

/// Wraps the `google_sign_in` plugin: shows Google's account picker and
/// hands back the account's ID token for `POST /auth/google`.
abstract class GoogleSignInDataSource {
  /// The signed-in account's Google ID token, or `null` if the user
  /// dismissed the account picker.
  Future<String?> getIdToken();

  /// Forgets the chosen Google account, so the next sign-in shows the
  /// account picker again instead of silently reusing it.
  Future<void> signOut();
}

class GoogleSignInDataSourceImpl implements GoogleSignInDataSource {
  GoogleSignInDataSourceImpl({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;
  Future<void>? _initialization;

  // `initialize` must run exactly once before any other call.
  Future<void> _ensureInitialized() => _initialization ??= _googleSignIn
      .initialize(serverClientId: AppConfig.googleServerClientId);

  @override
  Future<String?> getIdToken() async {
    await _ensureInitialized();
    try {
      final account = await _googleSignIn.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
  }
}
