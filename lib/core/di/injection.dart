import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/auth/datasources/remote/auth_remote_datasource.dart';
import '../../data/auth/repositories/auth_repository_impl.dart';
import '../../data/campus_directory/datasources/remote/campus_remote_datasource.dart';
import '../../data/campus_directory/repositories/campus_repository_impl.dart';
import '../../data/catalog/datasources/remote/catalog_remote_datasource.dart';
import '../../data/catalog/repositories/catalog_repository_impl.dart';
import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/auth/usecases/logout_usecase.dart';
import '../../domain/auth/usecases/request_otp_usecase.dart';
import '../../domain/auth/usecases/request_phone_change_otp_usecase.dart';
import '../../domain/auth/usecases/verify_otp_usecase.dart';
import '../../domain/auth/usecases/verify_phone_change_otp_usecase.dart';
import '../../domain/campus_directory/repositories/campus_repository.dart';
import '../../domain/campus_directory/usecases/get_campuses_usecase.dart';
import '../../domain/catalog/repositories/catalog_repository.dart';
import '../../domain/catalog/usecases/get_board_classes_usecase.dart';
import '../../domain/catalog/usecases/get_chapters_usecase.dart';
import '../../domain/catalog/usecases/get_class_levels_usecase.dart';
import '../../domain/catalog/usecases/get_questions_usecase.dart';
import '../../domain/catalog/usecases/get_subjects_usecase.dart';
import '../../domain/catalog/usecases/get_tests_usecase.dart';
import '../../data/student_onboarding/datasources/local/teacher_directory_dummy_datasource.dart';
import '../../data/student_onboarding/datasources/remote/student_remote_datasource.dart';
import '../../data/student_onboarding/repositories/student_repository_impl.dart';
import '../../data/student_onboarding/repositories/teacher_directory_repository_impl.dart';
import '../../data/teacher_onboarding/datasources/remote/teacher_remote_datasource.dart';
import '../../data/teacher_onboarding/repositories/teacher_repository_impl.dart';
import '../../domain/student_onboarding/repositories/student_repository.dart';
import '../../domain/student_onboarding/repositories/teacher_directory_repository.dart';
import '../../domain/student_onboarding/usecases/complete_student_onboarding_usecase.dart';
import '../../domain/student_onboarding/usecases/delete_student_account_usecase.dart';
import '../../domain/student_onboarding/usecases/update_student_usecase.dart';
import '../../domain/student_onboarding/usecases/get_students_for_teacher_usecase.dart';
import '../../domain/student_onboarding/usecases/get_teachers_for_campus_usecase.dart';
import '../../domain/teacher_onboarding/repositories/teacher_repository.dart';
import '../../domain/teacher_onboarding/usecases/delete_teacher_account_usecase.dart';
import '../../domain/teacher_onboarding/usecases/get_teacher_by_phone_usecase.dart';
import '../../domain/teacher_onboarding/usecases/sign_up_teacher_usecase.dart';
import '../../domain/teacher_onboarding/usecases/update_teacher_usecase.dart';
import '../../data/notifications/datasources/remote/notification_remote_datasource.dart';
import '../../data/notifications/repositories/notification_repository_impl.dart';
import '../../domain/notifications/repositories/notification_repository.dart';
import '../../domain/notifications/usecases/clear_all_notifications_usecase.dart';
import '../../domain/notifications/usecases/get_notifications_usecase.dart';
import '../../domain/notifications/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/notifications/usecases/mark_notification_read_usecase.dart';
import '../../data/live_test_registration/datasources/remote/live_test_registration_remote_datasource.dart';
import '../../data/live_test_registration/repositories/live_test_registration_repository_impl.dart';
import '../../domain/live_test_registration/repositories/live_test_registration_repository.dart';
import '../../domain/live_test_registration/usecases/get_live_test_registrations_usecase.dart';
import '../../domain/live_test_registration/usecases/register_for_live_test_usecase.dart';
import '../../data/earnings/datasources/remote/earnings_remote_datasource.dart';
import '../../data/earnings/repositories/earnings_repository_impl.dart';
import '../../domain/earnings/repositories/earnings_repository.dart';
import '../../domain/earnings/usecases/get_earnings_for_teacher_usecase.dart';
import '../../data/student_cart/datasources/remote/cart_remote_datasource.dart';
import '../../data/student_cart/repositories/cart_repository_impl.dart';
import '../../domain/student_cart/repositories/cart_repository.dart';
import '../../domain/student_cart/usecases/add_subject_bundle_usecase.dart';
import '../../domain/student_cart/usecases/checkout_usecase.dart';
import '../../domain/student_cart/usecases/get_cart_usecase.dart';
import '../../domain/student_cart/usecases/get_purchased_subject_ids_usecase.dart';
import '../../domain/student_cart/usecases/remove_from_cart_usecase.dart';
import '../../data/test_taking/datasources/remote/test_attempt_remote_datasource.dart';
import '../../data/test_taking/repositories/test_attempt_repository_impl.dart';
import '../../domain/test_taking/repositories/test_attempt_repository.dart';
import '../../domain/test_taking/usecases/get_attempt_usecase.dart';
import '../../domain/test_taking/usecases/get_student_test_attempts_usecase.dart';
import '../../domain/test_taking/usecases/start_test_attempt_usecase.dart';
import '../../domain/test_taking/usecases/submit_test_attempt_usecase.dart';
import '../network/dio_client.dart';
import '../services/logger.dart';

final GetIt sl = GetIt.instance;

/// Registers all repositories, use cases, and services with GetIt.
///
/// GetIt is used here purely as the composition root: it decouples object
/// construction from usage so implementations (e.g. dummy vs. real Dio-backed
/// repositories) can be swapped without touching call sites, and so tests can
/// register mocks instead. Riverpod providers in `riverpod_providers.dart`
/// wrap these instances so the rest of the app still consumes them
/// idiomatically via `ref.watch`/`ref.read`.
///
/// Each feature module appends its own registrations here as it's built.
void setupLocator() {
  sl.registerLazySingleton<Logger>(ConsoleLogger.new);
  sl.registerLazySingleton<Dio>(DioClient.build);

  // catalog
  sl.registerLazySingleton<CatalogRemoteDataSource>(
    () => CatalogRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => GetClassLevelsUseCase(sl()));
  sl.registerFactory(() => GetBoardClassesUseCase(sl()));
  sl.registerFactory(() => GetSubjectsUseCase(sl()));
  sl.registerFactory(() => GetChaptersUseCase(sl()));
  sl.registerFactory(() => GetTestsUseCase(sl()));
  sl.registerFactory(() => GetQuestionsUseCase(sl()));

  // campus-directory
  sl.registerLazySingleton<CampusRemoteDataSource>(
    () => CampusRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CampusRepository>(
    () => CampusRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton<GetCampusesUseCase>(
    () => GetCampusesUseCase(sl()),
  );

  // auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => RequestOtpUseCase(sl()));
  sl.registerFactory(() => VerifyOtpUseCase(sl()));
  sl.registerFactory(() => LogoutUseCase(sl()));
  sl.registerFactory(() => RequestPhoneChangeOtpUseCase(sl()));
  sl.registerFactory(() => VerifyPhoneChangeOtpUseCase(sl()));

  // teacher-onboarding
  sl.registerLazySingleton<TeacherRemoteDataSource>(
    () => TeacherRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TeacherRepository>(
    () => TeacherRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => GetTeacherByPhoneUseCase(sl()));
  sl.registerFactory(() => SignUpTeacherUseCase(sl()));
  sl.registerFactory(() => UpdateTeacherUseCase(sl()));
  sl.registerFactory(() => DeleteTeacherAccountUseCase(sl()));

  // student-onboarding
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => CompleteStudentOnboardingUseCase(sl()));
  sl.registerFactory(() => GetStudentsForTeacherUseCase(sl()));
  sl.registerFactory(() => UpdateStudentUseCase(sl()));
  sl.registerFactory(() => DeleteStudentAccountUseCase(sl()));
  sl.registerLazySingleton<TeacherDirectoryDummyDataSource>(
    TeacherDirectoryDummyDataSourceImpl.new,
  );
  sl.registerLazySingleton<TeacherDirectoryRepository>(
    () => TeacherDirectoryRepositoryImpl(dummy: sl()),
  );
  sl.registerFactory(() => GetTeachersForCampusUseCase(sl()));

  // notifications
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => GetNotificationsUseCase(sl()));
  sl.registerFactory(() => MarkNotificationReadUseCase(sl()));
  sl.registerFactory(() => MarkAllNotificationsReadUseCase(sl()));
  sl.registerFactory(() => ClearAllNotificationsUseCase(sl()));

  // earnings
  sl.registerLazySingleton<EarningsRemoteDataSource>(
    () => EarningsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<EarningsRepository>(
    () => EarningsRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => GetEarningsForTeacherUseCase(sl()));

  // student-cart
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => GetCartUseCase(sl()));
  sl.registerFactory(() => AddSubjectBundleUseCase(sl()));
  sl.registerFactory(() => RemoveFromCartUseCase(sl()));
  sl.registerFactory(() => CheckoutUseCase(sl()));
  sl.registerFactory(() => GetPurchasedSubjectIdsUseCase(sl()));

  // test-taking
  sl.registerLazySingleton<TestAttemptRemoteDataSource>(
    () => TestAttemptRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TestAttemptRepository>(
    () => TestAttemptRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => StartTestAttemptUseCase(sl()));
  sl.registerFactory(() => SubmitTestAttemptUseCase(sl()));
  sl.registerFactory(() => GetAttemptUseCase(sl()));

  // student-progress
  sl.registerFactory(() => GetStudentTestAttemptsUseCase(sl()));

  // live-test-registration
  sl.registerLazySingleton<LiveTestRegistrationRemoteDataSource>(
    () => LiveTestRegistrationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LiveTestRegistrationRepository>(
    () => LiveTestRegistrationRepositoryImpl(remote: sl()),
  );
  sl.registerFactory(() => RegisterForLiveTestUseCase(sl()));
  sl.registerFactory(() => GetLiveTestRegistrationsUseCase(sl()));
}
