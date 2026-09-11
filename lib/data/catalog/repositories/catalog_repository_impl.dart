import '../../../core/storage/local_cache_service.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/class_level.dart';
import '../../../domain/catalog/entities/ebook.dart';
import '../../../domain/catalog/entities/ebook_page.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/catalog/repositories/catalog_repository.dart';
import '../../../domain/common/result.dart';
import '../../common/swr_repository_mixin.dart';
import '../datasources/remote/catalog_remote_datasource.dart';
import '../models/board_class_dto.dart';
import '../models/class_level_dto.dart';

/// Maps [CatalogRemoteDataSource] DTOs to domain entities and implements
/// local-first Stale-While-Revalidate (SWR) caching.
class CatalogRepositoryImpl with SwrRepositoryMixin implements CatalogRepository {
  CatalogRepositoryImpl({
    required this.remote,
    required this.cache,
  });

  final CatalogRemoteDataSource remote;

  @override
  final LocalCacheService cache;

  List<ClassLevel>? _cachedClassLevels;
  List<BoardClass>? _cachedBoardClasses;
  final Map<String, List<Subject>> _cachedSubjectsByBoardClass = {};
  final Map<String, List<Chapter>> _cachedChaptersBySubject = {};
  final Map<String, List<Test>> _cachedTestsBySubject = {};
  final Map<String, List<Test>> _cachedTestsByChapter = {};
  final Map<String, List<Question>> _cachedQuestionsByTest = {};

  static const _classLevelsKey = 'cached_class_levels';
  static const _boardClassesKey = 'cached_board_classes';

  @override
  Future<Result<List<ClassLevel>>> getClassLevels({
    bool forceRefresh = false,
  }) {
    return fetchListWithSwr<ClassLevel>(
      cacheKey: _classLevelsKey,
      fromJson: (json) => ClassLevelDto.fromJson(json).toDomain(),
      toJson: (level) => ClassLevelDto.fromDomain(level).toJson(),
      fetchRemote: () async {
        final result = await remote.getClassLevels();
        return result.when(
          success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
          failure: (f) => ResultFailure(f),
        );
      },
      getMemory: () => _cachedClassLevels,
      setMemory: (value) => _cachedClassLevels = value,
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<Result<List<BoardClass>>> getBoardClasses({
    bool forceRefresh = false,
  }) {
    return fetchListWithSwr<BoardClass>(
      cacheKey: _boardClassesKey,
      fromJson: (json) => BoardClassDto.fromJson(json).toDomain(),
      toJson: (boardClass) => BoardClassDto.fromDomain(boardClass).toJson(),
      fetchRemote: () async {
        final result = await remote.getBoardClasses();
        return result.when(
          success: (dtos) => Success(dtos.map((d) => d.toDomain()).toList()),
          failure: (f) => ResultFailure(f),
        );
      },
      getMemory: () => _cachedBoardClasses,
      setMemory: (value) => _cachedBoardClasses = value,
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<Result<List<Subject>>> getSubjects(
    String boardClassId, {
    bool forceRefresh = false,
  }) async {
    if (_cachedSubjectsByBoardClass.containsKey(boardClassId) && !forceRefresh) {
      return Success(_cachedSubjectsByBoardClass[boardClassId]!);
    }
    final result = await remote.getSubjects(boardClassId);
    return result.when(
      success: (dtos) {
        final list = dtos.map((d) => d.toDomain()).toList();
        _cachedSubjectsByBoardClass[boardClassId] = list;
        return Success(list);
      },
      failure: (f) => _cachedSubjectsByBoardClass.containsKey(boardClassId)
          ? Success(_cachedSubjectsByBoardClass[boardClassId]!)
          : ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Chapter>>> getChapters(
    String subjectId, {
    bool forceRefresh = false,
  }) async {
    if (_cachedChaptersBySubject.containsKey(subjectId) && !forceRefresh) {
      return Success(_cachedChaptersBySubject[subjectId]!);
    }
    final result = await remote.getChapters(subjectId);
    return result.when(
      success: (dtos) {
        final list = dtos.map((d) => d.toDomain()).toList();
        _cachedChaptersBySubject[subjectId] = list;
        return Success(list);
      },
      failure: (f) => _cachedChaptersBySubject.containsKey(subjectId)
          ? Success(_cachedChaptersBySubject[subjectId]!)
          : ResultFailure(f),
    );
  }

  @override
  Future<Result<List<Test>>> getTests({
    String? subjectId,
    String? chapterId,
    bool forceRefresh = false,
  }) async {
    if (subjectId != null &&
        _cachedTestsBySubject.containsKey(subjectId) &&
        !forceRefresh) {
      return Success(_cachedTestsBySubject[subjectId]!);
    }
    if (chapterId != null &&
        _cachedTestsByChapter.containsKey(chapterId) &&
        !forceRefresh) {
      return Success(_cachedTestsByChapter[chapterId]!);
    }
    final result = await remote.getTests(
      subjectId: subjectId,
      chapterId: chapterId,
    );
    return result.when(
      success: (dtos) {
        final list = dtos.map((d) => d.toDomain()).toList();
        if (subjectId != null) {
          _cachedTestsBySubject[subjectId] = list;
        }
        if (chapterId != null) {
          _cachedTestsByChapter[chapterId] = list;
        }
        return Success(list);
      },
      failure: (f) {
        if (subjectId != null && _cachedTestsBySubject.containsKey(subjectId)) {
          return Success(_cachedTestsBySubject[subjectId]!);
        }
        if (chapterId != null && _cachedTestsByChapter.containsKey(chapterId)) {
          return Success(_cachedTestsByChapter[chapterId]!);
        }
        return ResultFailure(f);
      },
    );
  }

  @override
  Future<Result<List<Question>>> getQuestions(
    String testId, {
    bool forceRefresh = false,
  }) async {
    if (_cachedQuestionsByTest.containsKey(testId) && !forceRefresh) {
      return Success(_cachedQuestionsByTest[testId]!);
    }
    final result = await remote.getQuestions(testId);
    return result.when(
      success: (dtos) {
        final list = dtos.map((d) => d.toDomain()).toList();
        _cachedQuestionsByTest[testId] = list;
        return Success(list);
      },
      failure: (f) => _cachedQuestionsByTest.containsKey(testId)
          ? Success(_cachedQuestionsByTest[testId]!)
          : ResultFailure(f),
    );
  }

  @override
  Future<Result<Ebook>> getEbook(String subjectId) async {
    final result = await remote.getEbook(subjectId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<EbookPageWindow>> getEbookPages(
    String subjectId, {
    int startPage = 1,
    int count = 20,
  }) async {
    final result = await remote.getEbookPages(
      subjectId,
      startPage: startPage,
      count: count,
    );
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  void clearCache() {
    _cachedClassLevels = null;
    _cachedBoardClasses = null;
    _cachedSubjectsByBoardClass.clear();
    _cachedChaptersBySubject.clear();
    _cachedTestsBySubject.clear();
    _cachedTestsByChapter.clear();
    _cachedQuestionsByTest.clear();
  }
}
