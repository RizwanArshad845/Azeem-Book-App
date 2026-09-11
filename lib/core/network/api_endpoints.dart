/// Every backend path the app can call. Kept as a single enumeration per
/// §6.3 so dummy-vs-real datasource swaps never touch call sites, and so the
/// eventual Django backend has one canonical contract list to match.
class ApiEndpoints {
  const ApiEndpoints._();

  static const String authOtpRequest = '/auth/otp/request';
  static const String authOtpVerify = '/auth/otp/verify';
  static const String authPhoneChangeRequest = '/auth/phone-change/request';
  static const String authPhoneChangeVerify = '/auth/phone-change/verify';

  static const String catalogClassLevels = '/catalog/class-levels';
  static const String catalogBoardClasses = '/catalog/board-classes';
  static const String catalogSubjects = '/catalog/subjects';
  static const String catalogChapters = '/catalog/chapters';
  static const String catalogCampuses = '/catalog/campuses';
  static const String catalogTests = '/catalog/tests';
  static const String catalogQuestions = '/catalog/questions';
  static String catalogSubjectEbook(String subjectId) =>
      '/catalog/subjects/$subjectId/ebook';
  static String catalogSubjectEbookPages(String subjectId) =>
      '/catalog/subjects/$subjectId/ebook/pages';

  static const String teachers = '/teachers';
  static const String teacherSignUp = '/teachers/signup';
  static String teacherById(String teacherId) => '/teachers/$teacherId';
  static String teacherOverview(String teacherId) =>
      '/teachers/$teacherId/overview';
  static String teacherStudents(String teacherId) =>
      '/teachers/$teacherId/students';
  static String teacherEarnings(String teacherId) =>
      '/teachers/$teacherId/earnings';

  static const String studentSignUp = '/students/signup';
  static String studentById(String studentId) => '/students/$studentId';
  static String studentCart(String studentId) => '/students/$studentId/cart';
  static String studentProgress(String studentId) =>
      '/students/$studentId/progress';
  static String studentSubjectEnrollments(String studentId) =>
      '/students/$studentId/subject-enrollments';
  static String studentTestAttempts(String studentId) =>
      '/students/$studentId/test-attempts';

  static String testStartAttempt(String testId) =>
      '/tests/$testId/start-attempt';
  static String attemptSubmit(String attemptId) =>
      '/attempts/$attemptId/submit';
  static String attemptById(String attemptId) => '/attempts/$attemptId';

  static const String cartCheckout = '/cart/checkout';
  static const String paymentStatus = '/payments/status';

  static String notifications(String recipientId) =>
      '/notifications/$recipientId';
  static String notificationMarkRead(String notificationId) =>
      '/notifications/$notificationId/read';
  static String notificationsReadAll(String recipientId) =>
      '/notifications/$recipientId/read-all';
  static String notificationsClearAll(String recipientId) =>
      '/notifications/$recipientId/clear-all';

  static const String liveTestRegister = '/live-tests/register';
  static String liveTestRegistrationsForStudent(String studentId) =>
      '/live-tests/registrations/$studentId';
}
