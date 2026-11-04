import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Dedicated, tightly bounded disk cache for streamed (online) ebook pages,
/// instead of the app-wide `DefaultCacheManager` (30-day retention, 200
/// files). Keeps only a reading session's worth of pages for a day, so the
/// online reader never leaves a near-complete copy of a book lying around.
/// Emptied on logout. Offline copies live in the encrypted store, not here.
final ebookPageCacheManager = CacheManager(
  Config(
    'ebookPages',
    stalePeriod: const Duration(days: 1),
    maxNrOfCacheObjects: 60,
  ),
);
