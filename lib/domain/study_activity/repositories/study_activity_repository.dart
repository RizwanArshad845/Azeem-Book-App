import '../entities/last_activity.dart';

/// Device-local study bookmarks: the last opened subject/test/ebook and the
/// last viewed page of each ebook. Synchronous reads — backed by an
/// already-initialised local store, so the UI never waits on them.
abstract class StudyActivityRepository {
  LastActivity? getLastActivity();
  Future<void> saveLastActivity(LastActivity activity);

  /// 1-based page number last viewed in [subjectId]'s ebook, or null.
  int? getLastEbookPage(String subjectId);
  Future<void> saveLastEbookPage(String subjectId, int pageNumber);
}
