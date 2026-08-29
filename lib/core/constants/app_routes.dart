class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';

  // Auth (outside shell)
  static const String authRoleSelect = '/auth/role';
  static const String authPhone = '/auth/phone';
  static const String authOtp = '/auth/otp';

  // Teacher onboarding (outside shell)
  static const String teacherOnboardingSignup = '/teacher-onboarding/signup';
  static const String teacherOnboardingPending = '/teacher-onboarding/pending';
  static const String teacherOnboardingReview = '/teacher-onboarding/review';

  // Student onboarding (outside shell)
  static const String studentOnboardingBasicInfo =
      '/student-onboarding/basic-info';
  static const String studentOnboardingAcademicInfo =
      '/student-onboarding/academic-info';
  static const String studentOnboardingReview = '/student-onboarding/review';

  // Student shell tabs
  static const String studentHome = '/student/home';
  static const String studentHomeSubjectChapters =
      '/student/home/subject/:subjectId/chapters';
  static const String studentHomeChapterTests =
      '/student/home/subject/:subjectId/chapter/:chapterId/tests';
  static const String studentLiveTests = '/student/home/live-tests';
  static const String studentCart = '/student/cart';
  static const String studentProgress = '/student/progress';
  static const String studentNotifications = '/student/notifications';
  static const String studentProfile = '/student/profile';

  // Teacher shell tabs
  static const String teacherOverview = '/teacher/overview';
  static const String teacherStudents = '/teacher/students';
  static const String teacherEarnings = '/teacher/earnings';
  static const String teacherNotifications = '/teacher/notifications';
  static const String teacherProfile = '/teacher/profile';

  // Outside-shell, pushed on top (no bottom nav during a focused task)
  static const String testTaking = '/test-taking/:testId';
  static String testTakingPath(String testId) => '/test-taking/$testId';
  static const String cartCheckout = '/cart/checkout';
  static const String teacherStudentProgressDetail =
      '/teacher/students/:studentId/progress';
  static String teacherStudentProgressDetailPath(String studentId) =>
      '/teacher/students/$studentId/progress';
}
