class AppConfig {
  const AppConfig._();

  // TODO: point this at the real deployed Django backend before shipping —
  // this placeholder was only ever correct for `isMockMode` builds, which
  // no longer exist.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.azeempublications.dev',
  );

  static const bool enableLiveTests = true;
  static const bool enableGeminiOcr = false;

  /// Free test attempts a student gets across the whole app (any test, any
  /// chapter) before the upgrade/payment gate locks further attempts on
  /// unpurchased subjects. Purchased subjects are exempt from this cap (see
  /// `TestListView`/`TestResultsView`'s `isOwned` scoping).
  static const int freeAttemptsPerStudent = 2;

  static const int otpLength = 4;

  static const int splashDelaySeconds = 2;
}
