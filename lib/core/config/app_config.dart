class AppConfig {
  const AppConfig._();

  /// Sourced from `--dart-define=MOCK_MODE=true|false`; defaults to mock so
  /// local dev/demo builds never need the flag passed explicitly.
  static const bool isMockMode =
      bool.fromEnvironment('MOCK_MODE', defaultValue: true);

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
  static const String otpCode = '1234';
  static const int otpMaxAttempts = 3;
  static const int otpLockoutRestartSeconds = 3;

  static const int splashDelaySeconds = 2;
}
