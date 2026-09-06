import 'dart:async';

import '../../core/di/injection.dart';
import '../../core/services/logger.dart';
import '../../core/storage/local_cache_service.dart';
import '../../domain/common/result.dart';

/// Shared stale-while-revalidate (SWR) fetch logic for list-returning
/// repository methods backed by [LocalCacheService].
///
/// Order of resolution: in-memory cache → fresh disk cache (revalidating in
/// the background) → stale/missing disk cache (blocking network fetch,
/// falling back to the last known-good value on failure).
mixin SwrRepositoryMixin {
  LocalCacheService get cache;

  Future<Result<List<T>>> fetchListWithSwr<T>({
    required String cacheKey,
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T value) toJson,
    required Future<Result<List<T>>> Function() fetchRemote,
    required List<T>? Function() getMemory,
    required void Function(List<T> value) setMemory,
    Duration ttl = const Duration(hours: 12),
    bool forceRefresh = false,
  }) async {
    final memory = getMemory();
    if (memory != null && !forceRefresh) {
      return Success(memory);
    }

    if (memory == null) {
      final fromDisk = cache.getList<T>(cacheKey, fromJson);
      if (fromDisk != null && fromDisk.isNotEmpty) {
        setMemory(fromDisk);
        if (!forceRefresh && !cache.isStale(cacheKey, ttl: ttl)) {
          // Fresh enough to serve immediately; refresh in the background.
          unawaited(_revalidateList(
            cacheKey: cacheKey,
            toJson: toJson,
            fetchRemote: fetchRemote,
            setMemory: setMemory,
          ));
          return Success(fromDisk);
        }
      }
    }

    final result = await fetchRemote();
    return result.when(
      success: (list) {
        setMemory(list);
        cache.set(cacheKey, list.map(toJson).toList());
        return Success(list);
      },
      failure: (f) {
        final current = getMemory();
        return current != null ? Success(current) : ResultFailure(f);
      },
    );
  }

  Future<void> _revalidateList<T>({
    required String cacheKey,
    required Map<String, dynamic> Function(T value) toJson,
    required Future<Result<List<T>>> Function() fetchRemote,
    required void Function(List<T> value) setMemory,
  }) async {
    try {
      final result = await fetchRemote();
      result.when(
        success: (list) {
          setMemory(list);
          cache.set(cacheKey, list.map(toJson).toList());
        },
        failure: (f) => sl<Logger>().w(
          'SWR background revalidation failed for "$cacheKey": $f',
        ),
      );
    } catch (e, st) {
      sl<Logger>().e(
        'SWR background revalidation threw for "$cacheKey"',
        e,
        st,
      );
    }
  }
}
