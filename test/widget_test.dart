import 'package:azeem_book_app/app.dart';
import 'package:azeem_book_app/core/di/injection.dart';
import 'package:azeem_book_app/domain/campus_directory/entities/campus.dart';
import 'package:azeem_book_app/domain/campus_directory/repositories/campus_repository.dart';
import 'package:azeem_book_app/domain/catalog/entities/board_class.dart';
import 'package:azeem_book_app/domain/catalog/entities/chapter.dart';
import 'package:azeem_book_app/domain/catalog/entities/class_level.dart';
import 'package:azeem_book_app/domain/catalog/entities/ebook.dart';
import 'package:azeem_book_app/domain/catalog/entities/ebook_page.dart';
import 'package:azeem_book_app/domain/catalog/entities/question.dart';
import 'package:azeem_book_app/domain/catalog/entities/subject.dart';
import 'package:azeem_book_app/domain/catalog/entities/test.dart' as catalog;
import 'package:azeem_book_app/domain/catalog/repositories/catalog_repository.dart';
import 'package:azeem_book_app/domain/common/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The splash screen prefetches campuses/class-levels/board-classes/subjects
/// as soon as the app boots. Without these overrides that prefetch would
/// hit the real (Dio-backed) repositories registered by [setupLocator],
/// leaving real network timers pending past the end of this synchronous
/// widget test and tripping flutter_test's `!timersPending` teardown check.
class _FakeCampusRepository implements CampusRepository {
  @override
  Future<Result<List<Campus>>> getCampuses({bool forceRefresh = false}) async {
    return const Success(<Campus>[]);
  }

  @override
  void clearCache() {}
}

class _FakeCatalogRepository implements CatalogRepository {
  @override
  Future<Result<List<ClassLevel>>> getClassLevels({
    bool forceRefresh = false,
  }) async {
    return const Success(<ClassLevel>[]);
  }

  @override
  Future<Result<List<BoardClass>>> getBoardClasses({
    bool forceRefresh = false,
  }) async {
    return const Success(<BoardClass>[]);
  }

  @override
  Future<Result<List<Subject>>> getSubjects(
    String boardClassId, {
    bool forceRefresh = false,
  }) async {
    return const Success(<Subject>[]);
  }

  @override
  Future<Result<List<Chapter>>> getChapters(
    String subjectId, {
    bool forceRefresh = false,
  }) async {
    return const Success(<Chapter>[]);
  }

  @override
  Future<Result<List<catalog.Test>>> getTests({
    String? subjectId,
    String? chapterId,
    bool forceRefresh = false,
  }) async {
    return const Success(<catalog.Test>[]);
  }

  @override
  Future<Result<List<Question>>> getQuestions(
    String testId, {
    bool forceRefresh = false,
  }) async {
    return const Success(<Question>[]);
  }

  @override
  Future<Result<Ebook>> getEbook(String subjectId) async {
    return const Success(
      Ebook(subjectId: '', status: EbookStatus.pending),
    );
  }

  @override
  Future<Result<EbookPageWindow>> getEbookPages(
    String subjectId, {
    int startPage = 1,
    int count = 20,
  }) async {
    return const Success(
      EbookPageWindow(pages: <EbookPage>[], expiresInSeconds: 3600),
    );
  }

  @override
  void clearCache() {}
}

void main() {
  testWidgets('App boots to splash screen', (WidgetTester tester) async {
    setupLocator();
    sl
      ..unregister<CampusRepository>()
      ..registerLazySingleton<CampusRepository>(_FakeCampusRepository.new)
      ..unregister<CatalogRepository>()
      ..registerLazySingleton<CatalogRepository>(_FakeCatalogRepository.new);

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();

    expect(find.byType(App), findsOneWidget);
  });
}
