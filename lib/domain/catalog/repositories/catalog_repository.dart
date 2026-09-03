import '../../common/result.dart';
import '../entities/board_class.dart';
import '../entities/chapter.dart';
import '../entities/class_level.dart';
import '../entities/question.dart';
import '../entities/subject.dart';
import '../entities/test.dart';

/// Read-only access to Admin-authored catalog content: class levels,
/// board/classes, subjects, chapters, tests, and questions (project_spec.md
/// §9.2).
///
/// Concrete implementation calls the remote datasource directly — never
/// called directly from a viewmodel.
abstract class CatalogRepository {
  /// Every Admin-authored class level (enabled and disabled) — the coarser
  /// "9th"/"10th"/"11th"/"12th" grade axis that [BoardClass] leaves nest
  /// under (project_spec.md §9.2 `ClassLevel` prose).
  Future<Result<List<ClassLevel>>> getClassLevels();

  Future<Result<List<BoardClass>>> getBoardClasses();

  Future<Result<List<Subject>>> getSubjects(String boardClassId);

  Future<Result<List<Chapter>>> getChapters(String subjectId);

  /// At least one of [subjectId]/[chapterId] should be supplied by callers;
  /// both are accepted so chapter-wise and subject-wise listings share one
  /// method.
  Future<Result<List<Test>>> getTests({String? subjectId, String? chapterId});

  Future<Result<List<Question>>> getQuestions(String testId);
}
