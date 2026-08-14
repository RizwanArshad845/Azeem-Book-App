class AppConfig {
  const AppConfig._();

  static const int otpLength = 4;
  static const String otpCode = '1234';
  static const int otpMaxAttempts = 3;
  static const int otpLockoutRestartSeconds = 3;

  static const int testDurationMinutes = 10;
  static const int testQuestionCount = 20;
  static const int testShortQuestionCount = 2;

  static const double selfAssessmentWeight = 0.2;
  static const double testScoreWeight = 0.8;

  static const int splashDelaySeconds = 2;

  static const int classCodeLength = 6;

  static const int subjectCountMin = 1;
  static const int subjectCountMax = 8;

  static const List<String> subjectPool = [
    'Physics',
    'Chemistry',
    'Mathematics',
    'Biology',
    'Computer Science',
    'English',
    'Urdu',
    'Islamiat',
    'Pakistan Studies',
    'Statistics',
    'Economics',
  ];
}
