/// Every backend path the app can call. Kept as a single enumeration per
/// §6.3 so dummy-vs-real datasource swaps never touch call sites, and so the
/// eventual Django backend has one canonical contract list to match.
class ApiEndpoints {
  const ApiEndpoints._();

  static const String authOtpRequest = '/auth/otp/request';
  static const String authOtpVerify = '/auth/otp/verify';

  static const String catalogClassLevels = '/catalog/class-levels';
  static const String catalogBoardClasses = '/catalog/board-classes';
  static const String catalogSubjects = '/catalog/subjects';
  static const String catalogChapters = '/catalog/chapters';
  static const String catalogCampuses = '/catalog/campuses';
  static const String catalogTests = '/catalog/tests';
  static const String catalogQuestions = '/catalog/questions';

  static String teacherById(String teacherId) => '/teachers/$teacherId';
  static String teacherOverview(String teacherId) =>
      '/teachers/$teacherId/overview';
  static String teacherStudents(String teacherId) =>
      '/teachers/$teacherId/students';
  static String teacherEarnings(String teacherId) =>
      '/teachers/$teacherId/earnings';

  static String studentById(String studentId) => '/students/$studentId';
  static String studentCart(String studentId) => '/students/$studentId/cart';
  static String studentProgress(String studentId) =>
      '/students/$studentId/progress';
  static String studentSubjectEnrollments(String studentId) =>
      '/students/$studentId/subject-enrollments';
  static String studentTestAttempts(String studentId) =>
      '/students/$studentId/test-attempts';

  static String testSubmit(String testId) => '/tests/$testId/submit';

  static const String cartCheckout = '/cart/checkout';
  static const String paymentStatus = '/payments/status';

  static String notifications(String recipientId) =>
      '/notifications/$recipientId';
  static String notificationMarkRead(String notificationId) =>
      '/notifications/$notificationId/read';

  static const String liveTestRegister = '/live-tests/register';
  static String liveTestRegistrationsForStudent(String studentId) =>
      '/live-tests/registrations/$studentId';
}
