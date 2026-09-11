import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/result_guard.dart';
import '../../../../domain/common/result.dart';
import '../../models/board_class_dto.dart';
import '../../models/chapter_dto.dart';
import '../../models/class_level_dto.dart';
import '../../models/ebook_dto.dart';
import '../../models/ebook_page_dto.dart';
import '../../models/question_dto.dart';
import '../../models/subject_dto.dart';
import '../../models/test_dto.dart';

/// Dio-backed catalog datasource.
abstract class CatalogRemoteDataSource {
  Future<Result<List<ClassLevelDto>>> getClassLevels();

  Future<Result<List<BoardClassDto>>> getBoardClasses();

  Future<Result<List<SubjectDto>>> getSubjects(String boardClassId);

  Future<Result<List<ChapterDto>>> getChapters(String subjectId);

  Future<Result<List<TestDto>>> getTests({String? subjectId, String? chapterId});

  Future<Result<List<QuestionDto>>> getQuestions(String testId);

  Future<Result<EbookDto>> getEbook(String subjectId);

  Future<Result<EbookPagesResponseDto>> getEbookPages(
    String subjectId, {
    int startPage = 1,
    int count = 20,
  });
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  CatalogRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<List<ClassLevelDto>>> getClassLevels() {
    return _getList(
      ApiEndpoints.catalogClassLevels,
      ClassLevelDto.fromJson,
    );
  }

  @override
  Future<Result<List<BoardClassDto>>> getBoardClasses() {
    return _getList(
      ApiEndpoints.catalogBoardClasses,
      BoardClassDto.fromJson,
    );
  }

  @override
  Future<Result<List<SubjectDto>>> getSubjects(String boardClassId) {
    return _getList(
      ApiEndpoints.catalogSubjects,
      SubjectDto.fromJson,
      queryParameters: {'boardClassId': boardClassId},
    );
  }

  @override
  Future<Result<List<ChapterDto>>> getChapters(String subjectId) {
    return _getList(
      ApiEndpoints.catalogChapters,
      ChapterDto.fromJson,
      queryParameters: {'subjectId': subjectId},
    );
  }

  @override
  Future<Result<List<TestDto>>> getTests({
    String? subjectId,
    String? chapterId,
  }) {
    return _getList(
      ApiEndpoints.catalogTests,
      TestDto.fromJson,
      queryParameters: {
        'subjectId': ?subjectId,
        'chapterId': ?chapterId,
      },
    );
  }

  @override
  Future<Result<List<QuestionDto>>> getQuestions(String testId) {
    return _getList(
      ApiEndpoints.catalogQuestions,
      QuestionDto.fromJson,
      queryParameters: {'testId': testId},
    );
  }

  @override
  Future<Result<EbookDto>> getEbook(String subjectId) {
    return _get(ApiEndpoints.catalogSubjectEbook(subjectId), EbookDto.fromJson);
  }

  @override
  Future<Result<EbookPagesResponseDto>> getEbookPages(
    String subjectId, {
    int startPage = 1,
    int count = 20,
  }) {
    return _get(
      ApiEndpoints.catalogSubjectEbookPages(subjectId),
      EbookPagesResponseDto.fromJson,
      // Backend query params for this endpoint are snake_case
      // (`start_page`/`count`), unlike every other camelCase param above —
      // do not "normalize" these to camelCase.
      queryParameters: {'start_page': startPage, 'count': count},
    );
  }

  Future<Result<List<T>>> _getList<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) {
    return guardRequest(() async {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return (response.data ?? <dynamic>[])
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Result<T>> _get<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return fromJson(response.data!);
    });
  }
}
