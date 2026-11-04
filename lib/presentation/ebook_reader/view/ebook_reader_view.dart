import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/ebook_offline/entities/offline_ebook.dart';
import '../ebook_page_cache.dart';
import '../offline_reader_presence.dart';
import '../viewmodel/ebook_reader_viewmodel.dart';
import '../viewmodel/offline_ebook_viewmodel.dart';
import '../widgets/encrypted_page_image.dart';
import '../widgets/page_zoom_view.dart';
import '../widgets/reader_watermark.dart';

/// Page-streaming ebook reader (backend.md §2.2). Deliberately **not** a PDF
/// viewer — the backend never serves the source PDF, only per-page WebP
/// images behind short-lived signed URLs, so this is a plain image pager.
///
/// Two sources share one pager: online (signed URLs, streamed into a small
/// bounded cache) and [offline] (pages from the encrypted on-device store,
/// decrypted into memory only).
///
/// One page at a time (horizontal `PageView`). Each page fills the screen
/// width; a page taller than the screen scrolls vertically (orthogonal to the
/// horizontal swipe, so they don't conflict). Double-tap opens a full-screen
/// pinch-to-zoom view ([PageZoomView]). Tapping the page indicator jumps to a
/// page. Neighbouring pages are precached so forward paging shows no loader.
/// Every page carries a faint account watermark ([ReaderWatermark]).
///
/// Screenshots and screen recording are blocked for the lifetime of this
/// screen (`screen_protector`: Android `FLAG_SECURE` blocks both outright;
/// iOS has no OS-level screenshot block, so recording is only detected and
/// the screen is blurred in the app switcher / during an active recording).
class EbookReaderView extends ConsumerStatefulWidget {
  const EbookReaderView({
    super.key,
    required this.subjectId,
    this.offline = false,
  });

  final String subjectId;
  final bool offline;

  @override
  ConsumerState<EbookReaderView> createState() => _EbookReaderViewState();
}

class _EbookReaderViewState extends ConsumerState<EbookReaderView> {
  // screen_protector only ships native implementations for Android/iOS —
  // invoking it on desktop/web (this app's dev-loop platforms alongside
  // real devices) throws MissingPluginException, so guard every call.
  static bool get _isScreenProtectorSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    if (_isScreenProtectorSupported) {
      ScreenProtector.preventScreenshotOn();
      ScreenProtector.protectDataLeakageWithBlur();
    }
    if (widget.offline) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => offlineReaderOpen.value = true,
      );
    }
  }

  @override
  void dispose() {
    if (widget.offline) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => offlineReaderOpen.value = false,
      );
    }
    if (_isScreenProtectorSupported) {
      ScreenProtector.preventScreenshotOff();
      ScreenProtector.protectDataLeakageOff();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.ebookReaderTitle)),
      body: SafeArea(
        child: widget.offline ? _buildOffline() : _buildOnline(),
      ),
    );
  }

  Widget _buildOnline() {
    final provider = ebookReaderViewModelProvider(widget.subjectId);
    final readerAsync = ref.watch(provider);
    return AsyncValueWidget<EbookReaderState>(
      value: readerAsync,
      loading: () => const LoadingIndicator(),
      onRetry: () => ref.invalidate(provider),
      data: (readerState) {
        final urls = readerState.loadedPageUrls;
        return _EbookPager(
          pageCount: readerState.pageCount,
          // Identity changes whenever a new window of URLs arrives.
          pagesVersion: urls,
          imageFor: (pageNumber) {
            final url = urls[pageNumber];
            return url == null
                ? null
                : CachedNetworkImageProvider(
                    url,
                    cacheManager: ebookPageCacheManager,
                  );
          },
          onPageViewed: (pageNumber) =>
              ref.read(provider.notifier).onPageViewed(pageNumber),
          onPageError: (pageNumber) =>
              ref.read(provider.notifier).refreshUrlForPage(pageNumber),
        );
      },
    );
  }

  Widget _buildOffline() {
    final bookAsync = ref.watch(savedOfflineEbookProvider(widget.subjectId));
    final repository = ref.read(ebookOfflineRepositoryProvider);
    return AsyncValueWidget<OfflineEbook?>(
      value: bookAsync,
      loading: () => const LoadingIndicator(),
      data: (book) {
        if (book == null) {
          return EmptyStateView(
            icon: Icons.wifi_off_rounded,
            message: context.l10n.ebookOfflineMissing,
          );
        }
        return _EbookPager(
          pageCount: book.pageCount,
          pagesVersion: book,
          imageFor: (pageNumber) => EncryptedPageImage(
            repository: repository,
            subjectId: widget.subjectId,
            pageNumber: pageNumber,
          ),
        );
      },
    );
  }
}

class _EbookPager extends StatefulWidget {
  const _EbookPager({
    required this.pageCount,
    required this.pagesVersion,
    required this.imageFor,
    this.onPageViewed,
    this.onPageError,
  });

  final int pageCount;

  /// Changes (by identity) when more pages become available, so neighbours
  /// get re-warmed.
  final Object pagesVersion;

  /// Image for a 1-based page, or null while it isn't available yet.
  final ImageProvider? Function(int pageNumber) imageFor;

  /// Called (idempotently) as pages are built/viewed — lets the online
  /// source load page windows on demand.
  final Future<void> Function(int pageNumber)? onPageViewed;

  /// Called when a page fails to load — lets the online source refresh an
  /// expired signed URL.
  final Future<void> Function(int pageNumber)? onPageError;

  @override
  State<_EbookPager> createState() => _EbookPagerState();
}

class _EbookPagerState extends State<_EbookPager> {
  final PageController _pageController = PageController();

  // 0-based index of the visible page, for the page indicator. A notifier so
  // updating it repaints only the indicator, not the PageView.
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  // Pages for which a reload has already been requested, so a still-loading
  // placeholder frame never re-triggers the same request.
  final Set<int> _refreshRequestedForPage = {};

  @override
  void initState() {
    super.initState();
    // Precache page 1's neighbours so the first swipe is loader-free.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _precacheNeighbours(0);
    });
  }

  @override
  void didUpdateWidget(covariant _EbookPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    // More pages arrived — warm the current page's neighbours.
    if (!identical(oldWidget.pagesVersion, widget.pagesVersion)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _precacheNeighbours(_currentPage.value);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  // Decodes the images just off the current page so swiping to them shows
  // no placeholder. Same provider keys as _EbookPage resolves, so the decoded
  // entry is reused rather than re-fetched/re-decrypted.
  void _precacheNeighbours(int index) {
    final currentPageNumber = index + 1;
    for (final pageNumber in [
      currentPageNumber - 1,
      currentPageNumber + 1,
      currentPageNumber + 2,
    ]) {
      if (pageNumber < 1 || pageNumber > widget.pageCount) continue;
      final image = widget.imageFor(pageNumber);
      if (image != null) {
        precacheImage(image, context, onError: (_, _) {});
      }
    }
  }

  void _requestRefresh(int pageNumber) {
    final onPageError = widget.onPageError;
    if (onPageError == null) return;
    if (!_refreshRequestedForPage.add(pageNumber)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onPageError(
        pageNumber,
      ).whenComplete(() => _refreshRequestedForPage.remove(pageNumber));
    });
  }

  void _requestWindowFor(int pageNumber) {
    final onPageViewed = widget.onPageViewed;
    if (onPageViewed == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => onPageViewed(pageNumber));
  }

  Future<void> _openGoToPageDialog(int total) async {
    final target = await showDialog<int>(
      context: context,
      builder: (_) => _GoToPageDialog(total: total),
    );
    if (target == null || !mounted) return;
    _pageController.jumpToPage(target - 1);
    _currentPage.value = target - 1;
    _requestWindowFor(target);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.pageCount;
    if (total <= 0) {
      return Center(
        child: Text(
          context.l10n.commonErrorGeneric,
          style: TextStyle(color: context.colors.textSecondary),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: total,
          onPageChanged: (index) {
            _currentPage.value = index;
            _requestWindowFor(index + 1);
            _precacheNeighbours(index);
          },
          itemBuilder: (context, index) {
            final pageNumber = index + 1;
            // Load this page's window as it's built (covers the first page,
            // before any onPageChanged fires).
            _requestWindowFor(pageNumber);
            final image = widget.imageFor(pageNumber);
            if (image == null) {
              // Not available yet — brief loader until it arrives and this
              // rebuilds with the resolved image.
              return const Center(child: LoadingIndicator());
            }
            return _EbookPage(
              // Keyed by page number so a refreshed signed URL for the same
              // page reuses the same element instead of flashing a reload.
              key: ValueKey('ebook-page-$pageNumber'),
              image: image,
              onError: () => _requestRefresh(pageNumber),
            );
          },
        ),
        const Positioned.fill(child: ReaderWatermark()),
        Positioned(
          left: 0,
          right: 0,
          bottom: context.dimens.md,
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, current, _) => _PageIndicator(
                current: current + 1,
                total: total,
                onTap: () => _openGoToPageDialog(total),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A single ebook page: full screen width, vertically scrollable when taller
/// than the screen (centred when shorter). Double-tap opens the full-screen
/// pinch-to-zoom view.
class _EbookPage extends StatelessWidget {
  const _EbookPage({super.key, required this.image, required this.onError});

  final ImageProvider image;
  final VoidCallback onError;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Reserve a book-page-ish height (≈0.71 aspect) while loading so the
        // scroll view has a definite size before the image resolves.
        final placeholderHeight = width / 0.71;
        Widget placeholder() => SizedBox(
              width: width,
              height: placeholderHeight,
              child: const LoadingIndicator(),
            );

        return GestureDetector(
          onDoubleTap: () => PageZoomView.open(context, image),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Image(
                  image: image,
                  width: width,
                  fit: BoxFit.fitWidth,
                  gaplessPlayback: true,
                  frameBuilder: (context, child, frame, wasSync) =>
                      frame == null && !wasSync ? placeholder() : child,
                  errorBuilder: (context, _, _) {
                    onError();
                    return placeholder();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.current,
    required this.total,
    required this.onTap,
  });

  final int current;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.dimens.lg),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimens.md,
            vertical: context.dimens.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(context.dimens.lg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book_outlined,
                  color: Colors.white, size: 15),
              SizedBox(width: context.dimens.xs),
              Text(
                '$current / $total',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Numeric "go to page" prompt; pops the chosen 1-based page number, or null
/// on cancel.
class _GoToPageDialog extends StatefulWidget {
  const _GoToPageDialog({required this.total});

  final int total;

  @override
  State<_GoToPageDialog> createState() => _GoToPageDialogState();
}

class _GoToPageDialogState extends State<_GoToPageDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < 1 || value > widget.total) {
      setState(() => _error = context.l10n.ebookGoToPageInvalid(widget.total));
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.ebookGoToPageTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: context.l10n.ebookGoToPageLabel,
          suffixText: '/ ${widget.total}',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        AppButton(
          label: context.l10n.commonCancel,
          variant: AppButtonVariant.text,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: context.l10n.ebookGoToPageButton,
          onPressed: _submit,
        ),
      ],
    );
  }
}
