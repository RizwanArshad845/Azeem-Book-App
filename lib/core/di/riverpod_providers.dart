import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/diagnostic/usecases/build_test_session_usecase.dart';
import '../../domain/diagnostic/usecases/calculate_results_usecase.dart';
import '../../domain/diagnostic/usecases/grade_short_answer_usecase.dart';
import '../../domain/onboarding/repositories/city_repository.dart';
import '../../domain/onboarding/repositories/college_repository.dart';
import '../../domain/onboarding/repositories/subject_repository.dart';
import '../../domain/question_bank/repositories/question_bank_repository.dart';
import '../services/logger.dart';
import 'injection.dart';

final loggerProvider = Provider<Logger>((ref) => sl<Logger>());

final questionBankRepositoryProvider =
    Provider<QuestionBankRepository>((ref) => sl<QuestionBankRepository>());

final collegeRepositoryProvider =
    Provider<CollegeRepository>((ref) => sl<CollegeRepository>());

final cityRepositoryProvider =
    Provider<CityRepository>((ref) => sl<CityRepository>());

final subjectRepositoryProvider =
    Provider<SubjectRepository>((ref) => sl<SubjectRepository>());

final buildTestSessionUseCaseProvider =
    Provider<BuildTestSessionUseCase>((ref) => sl<BuildTestSessionUseCase>());

final gradeShortAnswerUseCaseProvider = Provider<GradeShortAnswerUseCase>(
    (ref) => sl<GradeShortAnswerUseCase>());

final calculateResultsUseCaseProvider = Provider<CalculateResultsUseCase>(
    (ref) => sl<CalculateResultsUseCase>());
