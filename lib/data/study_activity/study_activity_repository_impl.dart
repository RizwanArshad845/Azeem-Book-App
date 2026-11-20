import '../../core/storage/local_cache_service.dart';
import '../../domain/study_activity/entities/last_activity.dart';
import '../../domain/study_activity/repositories/study_activity_repository.dart';

/// [StudyActivityRepository] over the app's `shared_preferences`-backed
/// [LocalCacheService]. Cleared together with the rest of the local cache.
class StudyActivityRepositoryImpl implements StudyActivityRepository {
  StudyActivityRepositoryImpl(this._cache);

  final LocalCacheService _cache;

  static const _lastActivityKey = 'study_activity.last';
  static String _ebookPageKey(String subjectId) =>
      'study_activity.ebook_page.$subjectId';

  @override
  LastActivity? getLastActivity() =>
      _cache.get<LastActivity?>(_lastActivityKey, LastActivity.tryFromJson);

  @override
  Future<void> saveLastActivity(LastActivity activity) =>
      _cache.set(_lastActivityKey, activity.toJson());

  @override
  int? getLastEbookPage(String subjectId) => _cache.get<int?>(
    _ebookPageKey(subjectId),
    (json) => json['page'] is int ? json['page'] as int : null,
  );

  @override
  Future<void> saveLastEbookPage(String subjectId, int pageNumber) =>
      _cache.set(_ebookPageKey(subjectId), {'page': pageNumber});
}
