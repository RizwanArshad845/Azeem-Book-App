import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/class_level.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/catalog/repositories/catalog_repository.dart';
import '../../../domain/common/result.dart';
import '../datasources/remote/catalog_remote_datasource.dart';

/// Maps [CatalogRemoteDataSource] DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required this.remote});

  final CatalogRemoteDataSource remote;

  @override
  Future<Result<List<ClassLevel>>> getClassLevels() async {
    final result = await remote.getClassLevels();
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<BoardClass>>> getBoardClasses() async {
    final result = await remote.getBoardClasses();
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Subject>>> getSubjects(String boardClassId) async {
    final result = await remote.getSubjects(boardClassId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Chapter>>> getChapters(String subjectId) async {
    final result = await remote.getChapters(subjectId);
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
    final result = await remote.getTests(
      subjectId: subjectId,
      chapterId: chapterId,
    );
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Question>>> getQuestions(String testId) async {
    final result = await remote.getQuestions(testId);
    return result.when(
      success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
      failure: (f) => ResultFailure(f),
    );
  }
}
