import '../../common/result.dart';
import '../entities/board_class.dart';
import '../entities/chapter.dart';
import '../entities/question.dart';
import '../entities/subject.dart';
import '../entities/test.dart';

/// Read-only access to Admin-authored catalog content: board/classes,
/// subjects, chapters, tests, and questions (project_spec.md §9.2).
///
/// Concrete implementation picks a dummy or remote datasource based on
/// `AppConfig.isMockMode` (§6.2) — never called directly from a viewmodel.
abstract class CatalogRepository {
  Future<Result<List<BoardClass>>> getBoardClasses();

  Future<Result<List<Subject>>> getSubjects(String boardClassId);

  Future<Result<List<Chapter>>> getChapters(String subjectId);

  /// At least one of [subjectId]/[chapterId] should be supplied by callers;
  /// both are accepted so chapter-wise and subject-wise listings share one
  /// method.
  Future<Result<List<Test>>> getTests({String? subjectId, String? chapterId});

  Future<Result<List<Question>>> getQuestions(String testId);
}
