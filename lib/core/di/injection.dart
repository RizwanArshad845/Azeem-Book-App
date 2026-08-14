import 'package:get_it/get_it.dart';

import '../../data/onboarding/repositories/city_repository_impl.dart';
import '../../data/onboarding/repositories/college_repository_impl.dart';
import '../../data/onboarding/repositories/subject_repository_impl.dart';
import '../../data/question_bank/repositories/question_bank_repository_impl.dart';
import '../../domain/diagnostic/usecases/build_test_session_usecase.dart';
import '../../domain/diagnostic/usecases/calculate_results_usecase.dart';
import '../../domain/diagnostic/usecases/grade_short_answer_usecase.dart';
import '../../domain/onboarding/repositories/city_repository.dart';
import '../../domain/onboarding/repositories/college_repository.dart';
import '../../domain/onboarding/repositories/subject_repository.dart';
import '../../domain/question_bank/repositories/question_bank_repository.dart';
import '../services/logger.dart';

final GetIt sl = GetIt.instance;

/// Registers all repositories, use cases, and services with GetIt.
///
/// GetIt is used here purely as the composition root: it decouples object
/// construction from usage so implementations (e.g. a future
/// Supabase/HTTP-backed [QuestionBankRepository]) can be swapped without
/// touching call sites, and so tests can register mocks instead. Riverpod
/// providers in `riverpod_providers.dart` wrap these instances so the rest
/// of the app still consumes them idiomatically via `ref.watch`/`ref.read`.
void setupLocator() {
  sl.registerLazySingleton<Logger>(ConsoleLogger.new);

  sl.registerLazySingleton<QuestionBankRepository>(
      QuestionBankRepositoryImpl.new);
  sl.registerLazySingleton<CollegeRepository>(CollegeRepositoryImpl.new);
  sl.registerLazySingleton<SubjectRepository>(SubjectRepositoryImpl.new);
  sl.registerLazySingleton<CityRepository>(CityRepositoryImpl.new);

  sl.registerLazySingleton<BuildTestSessionUseCase>(
      () => const BuildTestSessionUseCase());
  sl.registerLazySingleton<GradeShortAnswerUseCase>(
      () => const GradeShortAnswerUseCase());
  sl.registerLazySingleton<CalculateResultsUseCase>(
      () => const CalculateResultsUseCase());
}
