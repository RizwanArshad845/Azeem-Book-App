class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'https://backend-azeem-book-production.up.railway.app/api/v1',
  );

  static const bool enableLiveTests = true;
  static const bool enableGeminiOcr = false;

  /// Free test attempts a student gets across the whole app (any test, any
  /// chapter) before the upgrade/payment gate locks further attempts on
  /// unpurchased subjects. Purchased subjects are exempt from this cap (see
  /// `TestListView`/`TestResultsView`'s `isOwned` scoping).
  static const int freeAttemptsPerStudent = 2;

  /// The Google Cloud **Web application** OAuth client id. Google Sign-In
  /// issues the ID token for this audience, and the backend only accepts
  /// tokens issued for the ids in its `GOOGLE_OAUTH_CLIENT_IDS` — the two
  /// must match. Not a secret. Override per build with
  /// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '1052720200226-s0699tea7rm925innbg882gl2hihn2ef.apps.googleusercontent.com',
  );

  static const int splashDelaySeconds = 2;
}
