import 'dart:async' show unawaited;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../core/utils/concurrency_gate.dart';
import '../../../domain/catalog/entities/ebook_page.dart';

/// State for a single ebook-reading session: the book's total page count
/// (from ebook metadata) plus every page-image URL fetched so far, keyed by
/// page number. `loadedPageUrls` is sparse — the reader loads page windows on
/// demand around wherever the student currently is (including arbitrary
/// jumps), so it can have gaps.
class EbookReaderState {
  const EbookReaderState({
    required this.pageCount,
    required this.loadedPageUrls,
  });

  final int pageCount;
  final Map<int, String> loadedPageUrls;

  EbookReaderState copyWith({Map<int, String>? loadedPageUrls}) {
    return EbookReaderState(
      pageCount: pageCount,
      loadedPageUrls: loadedPageUrls ?? this.loadedPageUrls,
    );
  }
}

/// Drives the page-streaming ebook reader (backend.md §2.2): fetches pages in
/// windows of [_windowSize] on demand around the current page, silently
/// prefetching the neighbouring windows and each window's images so paging
/// (and jumping) rarely shows a loader, and silently re-fetching a single
/// window when a cached signed URL has expired (403).
class EbookReaderViewModel extends AsyncNotifier<EbookReaderState> {
  EbookReaderViewModel(this._subjectId);

  final String _subjectId;

  static const _windowSize = 20;
  static const _prefetchThreshold = 5;

  // Windows (keyed by their start page) whose URLs are in state, and those
  // whose fetch is currently in flight — so a window is fetched at most once.
  final Set<int> _loadedWindowStarts = {};
  final Set<int> _inFlightWindowStarts = {};

  // Caps how many page-image downloads this reader session kicks off in the
  // background at once, so warming the cache for a freshly-fetched window
  // doesn't itself fire 20 simultaneous requests.
  final _imagePrefetchGate = ConcurrencyGate(3);

  int _windowStartFor(int pageNumber) =>
      ((pageNumber - 1) ~/ _windowSize) * _windowSize + 1;

  @override
  Future<EbookReaderState> build() async {
    final ebookResult = await ref.read(getEbookUseCaseProvider)(_subjectId);
    final ebook = ebookResult.when(
      success: (e) => e,
      failure: (f) => throw f,
    );

    final window = await _fetchWindow(startPage: 1, count: _windowSize);
    _loadedWindowStarts.add(1);
    if (window.pages.isNotEmpty) {
      // Wait for page 1's image specifically (bounded, so a slow/broken first
      // image can't hang the screen forever) so the reader only appears once
      // there's something to show; the rest prefetches in the background.
      try {
        await DefaultCacheManager()
            .getSingleFile(window.pages.first.url)
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        // Best-effort — page 1 falls back to its own on-build load.
      }
      _prefetchImages(window.pages.skip(1).toList());
    }
    return EbookReaderState(
      pageCount: ebook.pageCount ?? 0,
      loadedPageUrls: {for (final p in window.pages) p.pageNumber: p.url},
    );
  }

  Future<EbookPageWindow> _fetchWindow({
    required int startPage,
    required int count,
  }) async {
    final result = await ref.read(
      getEbookPagesUseCaseProvider,
    )(_subjectId, startPage: startPage, count: count);
    return result.when(success: (w) => w, failure: (f) => throw f);
  }

  // Downloads each page's image into the cache `CachedNetworkImage` reads
  // from, ahead of the reader scrolling to it, so the page shows up instantly
  // instead of flashing a loading spinner. Best-effort.
  void _prefetchImages(List<EbookPage> pages) {
    for (final page in pages) {
      unawaited(
        _imagePrefetchGate.acquire().then((_) async {
          try {
            await DefaultCacheManager().getSingleFile(page.url);
          } catch (_) {
            // Ignored — see doc comment above.
          } finally {
            _imagePrefetchGate.release();
          }
        }),
      );
    }
  }

  /// Fetches the window starting at [startPage] if it isn't already loaded (or
  /// in flight), merging its URLs into state and prefetching its images. Pass
  /// [force] to re-fetch a window whose signed URLs have expired.
  Future<void> _ensureWindow(int startPage, {bool force = false}) async {
    final current = state.value;
    if (current == null) return;
    if (startPage < 1 || startPage > current.pageCount) return;
    if (!force && _loadedWindowStarts.contains(startPage)) return;
    if (_inFlightWindowStarts.contains(startPage)) return;

    _inFlightWindowStarts.add(startPage);
    try {
      final window = await _fetchWindow(startPage: startPage, count: _windowSize);
      _prefetchImages(window.pages);
      final latest = state.value;
      if (latest == null) return;
      final merged = {...latest.loadedPageUrls};
      for (final p in window.pages) {
        merged[p.pageNumber] = p.url;
      }
      state = AsyncData(latest.copyWith(loadedPageUrls: merged));
      _loadedWindowStarts.add(startPage);
    } catch (_) {
      // Background load — a transient failure just means the next
      // onPageViewed (or a page's own error retry) tries again.
    } finally {
      _inFlightWindowStarts.remove(startPage);
    }
  }

  /// Call as the reader's current page changes (including after a jump).
  /// Loads the window containing [pageNumber] on demand, and prefetches the
  /// neighbouring windows so forward/backward paging stays loader-free.
  Future<void> onPageViewed(int pageNumber) async {
    final windowStart = _windowStartFor(pageNumber);
    await _ensureWindow(windowStart);

    // Prefetch the next window once near this window's trailing edge.
    if (pageNumber >= windowStart + _windowSize - _prefetchThreshold) {
      unawaited(_ensureWindow(windowStart + _windowSize));
    }
    // Prefetch the previous window once near this window's leading edge, for
    // smooth backward paging.
    if (windowStart > 1 && pageNumber <= windowStart + _prefetchThreshold) {
      unawaited(_ensureWindow(windowStart - _windowSize));
    }
  }

  /// Re-fetches the single window containing [pageNumber] — used when a
  /// cached-but-unopened signed URL has expired (§2.2 step 4: expected
  /// behavior, not a hard error).
  Future<void> refreshUrlForPage(int pageNumber) {
    return _ensureWindow(_windowStartFor(pageNumber), force: true);
  }
}

final ebookReaderViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<EbookReaderViewModel, EbookReaderState, String>(
      EbookReaderViewModel.new,
    );
