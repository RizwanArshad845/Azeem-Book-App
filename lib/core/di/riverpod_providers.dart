import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/campus_directory/entities/campus.dart';
import '../../domain/campus_directory/repositories/campus_repository.dart';
import '../../domain/campus_directory/usecases/get_campuses_usecase.dart';
import '../../domain/catalog/entities/board_class.dart';
import '../../domain/catalog/entities/class_level.dart';
import '../../domain/catalog/repositories/catalog_repository.dart';
import '../../domain/catalog/usecases/get_board_classes_usecase.dart';
import '../../domain/catalog/usecases/get_chapters_usecase.dart';
import '../../domain/catalog/usecases/get_class_levels_usecase.dart';
import '../../domain/catalog/usecases/get_ebook_pages_usecase.dart';
import '../../domain/catalog/usecases/get_ebook_usecase.dart';
import '../../domain/catalog/usecases/get_questions_usecase.dart';
import '../../domain/catalog/usecases/get_subjects_usecase.dart';
import '../../domain/catalog/usecases/get_tests_usecase.dart';
import '../../domain/notifications/repositories/notification_repository.dart';
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
final getEbookUseCaseProvider =
    Provider<GetEbookUseCase>((ref) => sl<GetEbookUseCase>());
final getEbookPagesUseCaseProvider =
    Provider<GetEbookPagesUseCase>((ref) => sl<GetEbookPagesUseCase>());

final classLevelsProvider = FutureProvider<List<ClassLevel>>((ref) async {
  final result = await ref.read(getClassLevelsUseCaseProvider)();
  return result.when(
    success: (classLevels) => classLevels,
    failure: (failure) => throw failure,
  );
});

final boardClassesProvider = FutureProvider<List<BoardClass>>((ref) async {
  final result = await ref.read(getBoardClassesUseCaseProvider)();
  return result.when(
    success: (boardClasses) => boardClasses,
    failure: (failure) => throw failure,
  );
});

// campus-directory
final campusRepositoryProvider =
    Provider<CampusRepository>((ref) => sl<CampusRepository>());
final getCampusesUseCaseProvider =
    Provider<GetCampusesUseCase>((ref) => sl<GetCampusesUseCase>());

final campusesProvider = FutureProvider<List<Campus>>((ref) async {
  final result = await ref.read(getCampusesUseCaseProvider)();
  return result.when(
    success: (campuses) => campuses,
    failure: (failure) => throw failure,
  );
});

// notifications
final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) => sl<NotificationRepository>());

// auth: authViewModelProvider / currentUserProvider live in
// presentation/auth/viewmodel/auth_viewmodel.dart (self-contained, same
// pattern as splashViewModelProvider).
