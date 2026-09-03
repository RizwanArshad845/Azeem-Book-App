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

  static const int otpLength = 6;

  static const int splashDelaySeconds = 2;
}
