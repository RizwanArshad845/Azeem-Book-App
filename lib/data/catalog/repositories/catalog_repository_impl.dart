import '../../../core/config/app_config.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/catalog/repositories/catalog_repository.dart';
import '../../../domain/common/result.dart';
import '../datasources/local/catalog_dummy_datasource.dart';
import '../datasources/remote/catalog_remote_datasource.dart';

/// Switches between [CatalogRemoteDataSource] and [CatalogDummyDataSource]
/// based on `AppConfig.isMockMode` (project_spec.md §6.2) and maps DTOs to
/// domain entities so nothing above this layer ever sees a DTO.
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({
    required this.remote,
    required this.dummy,
    this.isMockMode = AppConfig.isMockMode,
  });

  final CatalogRemoteDataSource remote;
  final CatalogDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<List<BoardClass>>> getBoardClasses() async {
    final result = isMockMode
        ? await dummy.getBoardClasses()
        : await remote.getBoardClasses();
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Subject>>> getSubjects(String boardClassId) async {
    final result = isMockMode
        ? await dummy.getSubjects(boardClassId)
        : await remote.getSubjects(boardClassId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Chapter>>> getChapters(String subjectId) async {
    final result = isMockMode
        ? await dummy.getChapters(subjectId)
        : await remote.getChapters(subjectId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Test>>> getTests({
    String? subjectId,
    String? chapterId,
  }) async {
    final result = isMockMode
        ? await dummy.getTests(subjectId: subjectId, chapterId: chapterId)
        : await remote.getTests(subjectId: subjectId, chapterId: chapterId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Question>>> getQuestions(String testId) async {
    final result = isMockMode
        ? await dummy.getQuestions(testId)
        : await remote.getQuestions(testId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
