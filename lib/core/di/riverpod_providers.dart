import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/campus_directory/repositories/campus_repository.dart';
import '../../domain/campus_directory/usecases/get_campuses_usecase.dart';
import '../../domain/catalog/repositories/catalog_repository.dart';
import '../../domain/catalog/usecases/get_board_classes_usecase.dart';
import '../../domain/catalog/usecases/get_chapters_usecase.dart';
import '../../domain/catalog/usecases/get_class_levels_usecase.dart';
import '../../domain/catalog/usecases/get_questions_usecase.dart';
import '../../domain/catalog/usecases/get_subjects_usecase.dart';
import '../../domain/catalog/usecases/get_tests_usecase.dart';
import '../services/logger.dart';
import 'injection.dart';

final loggerProvider = Provider<Logger>((ref) => sl<Logger>());

// catalog
final catalogRepositoryProvider =
    Provider<CatalogRepository>((ref) => sl<CatalogRepository>());
final getClassLevelsUseCaseProvider =
    Provider<GetClassLevelsUseCase>((ref) => sl<GetClassLevelsUseCase>());
final getBoardClassesUseCaseProvider =
    Provider<GetBoardClassesUseCase>((ref) => sl<GetBoardClassesUseCase>());
final getSubjectsUseCaseProvider =
    Provider<GetSubjectsUseCase>((ref) => sl<GetSubjectsUseCase>());
final getChaptersUseCaseProvider =
    Provider<GetChaptersUseCase>((ref) => sl<GetChaptersUseCase>());
final getTestsUseCaseProvider =
    Provider<GetTestsUseCase>((ref) => sl<GetTestsUseCase>());
final getQuestionsUseCaseProvider =
    Provider<GetQuestionsUseCase>((ref) => sl<GetQuestionsUseCase>());

// campus-directory
final campusRepositoryProvider =
    Provider<CampusRepository>((ref) => sl<CampusRepository>());
final getCampusesUseCaseProvider =
    Provider<GetCampusesUseCase>((ref) => sl<GetCampusesUseCase>());

// auth: authViewModelProvider / currentUserProvider live in
// presentation/auth/viewmodel/auth_viewmodel.dart (self-contained, same
// pattern as splashViewModelProvider).
