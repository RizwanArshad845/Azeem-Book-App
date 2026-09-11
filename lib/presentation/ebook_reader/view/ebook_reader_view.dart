import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../viewmodel/ebook_reader_viewmodel.dart';
import '../widgets/page_zoom_view.dart';

/// Page-streaming ebook reader (backend.md §2.2). Deliberately **not** a PDF
/// viewer — the backend never serves the source PDF, only per-page WebP
/// images behind short-lived signed URLs, so this is a plain image pager.
///
/// One page at a time (horizontal `PageView`). Each page fills the screen
/// width; a page taller than the screen scrolls vertically (orthogonal to the
/// horizontal swipe, so they don't conflict). Double-tap opens a full-screen
/// pinch-to-zoom view ([PageZoomView]). Tapping the page indicator jumps to a
/// page. Neighbouring pages are precached so forward paging shows no loader.
///
/// Screenshots and screen recording are blocked for the lifetime of this
/// screen (`screen_protector`: Android `FLAG_SECURE` blocks both outright;
/// iOS has no OS-level screenshot block, so recording is only detected and
/// the screen is blurred in the app switcher / during an active recording).
class EbookReaderView extends ConsumerStatefulWidget {
  const EbookReaderView({super.key, required this.subjectId});

  final String subjectId;

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
  }

  @override
  void dispose() {
    if (_isScreenProtectorSupported) {
      ScreenProtector.preventScreenshotOff();
      ScreenProtector.protectDataLeakageOff();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readerAsync = ref.watch(
      ebookReaderViewModelProvider(widget.subjectId),
    );

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.ebookReaderTitle)),
      body: SafeArea(
        child: AsyncValueWidget<EbookReaderState>(
          value: readerAsync,
          loading: () => const LoadingIndicator(),
          onRetry: () => ref.invalidate(
            ebookReaderViewModelProvider(widget.subjectId),
          ),
          data: (readerState) => _EbookPager(
            subjectId: widget.subjectId,
            state: readerState,
          ),
        ),
      ),
    );
  }
}

class _EbookPager extends ConsumerStatefulWidget {
  const _EbookPager({required this.subjectId, required this.state});

  final String subjectId;
  final EbookReaderState state;

  @override
  ConsumerState<_EbookPager> createState() => _EbookPagerState();
}

class _EbookPagerState extends ConsumerState<_EbookPager> {
  final PageController _pageController = PageController();

  // 0-based index of the visible page, for the page indicator. A notifier so
  // updating it repaints only the indicator, not the PageView.
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  // Pages for which a stale-URL refresh has already been requested, so a
  // still-loading placeholder frame never re-triggers the same request.
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
    // A newly-fetched window arrived — warm the current page's neighbours.
    if (!identical(
      oldWidget.state.loadedPageUrls,
      widget.state.loadedPageUrls,
    )) {
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

  // Decodes the images just off the current page into the cache so swiping to
  // them shows no placeholder. Uses a plain CachedNetworkImageProvider — the
  // same key _EbookPage's CachedNetworkImage resolves — so the decoded entry
  // is reused rather than re-fetched.
  void _precacheNeighbours(int index) {
    final urls = widget.state.loadedPageUrls;
    final currentPageNumber = index + 1;
    for (final pageNumber in [
      currentPageNumber - 1,
      currentPageNumber + 1,
      currentPageNumber + 2,
    ]) {
      if (pageNumber < 1) continue;
      final url = urls[pageNumber];
      if (url != null) {
        precacheImage(CachedNetworkImageProvider(url), context);
      }
    }
  }

  void _requestUrlRefresh(int pageNumber) {
    if (!_refreshRequestedForPage.add(pageNumber)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(ebookReaderViewModelProvider(widget.subjectId).notifier)
          .refreshUrlForPage(pageNumber)
          .whenComplete(() => _refreshRequestedForPage.remove(pageNumber));
    });
  }

  // `onPageViewed` loads the window around [pageNumber] on demand and is
  // idempotent, so it's safe to call on every page build / change.
  void _requestWindowFor(int pageNumber) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(ebookReaderViewModelProvider(widget.subjectId).notifier)
          .onPageViewed(pageNumber);
    });
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
    final state = widget.state;
    final total = state.pageCount;
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
            final url = state.loadedPageUrls[pageNumber];
            if (url == null) {
              // Window not fetched yet — brief loader until it arrives and
              // this rebuilds with the resolved URL.
              return const Center(child: LoadingIndicator());
            }
            return _EbookPage(
              // Keyed by page number so a refreshed signed URL for the same
              // page reuses the same element instead of flashing a reload.
              key: ValueKey('ebook-page-$pageNumber'),
              imageUrl: url,
              onError: () => _requestUrlRefresh(pageNumber),
            );
          },
        ),
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
  const _EbookPage({super.key, required this.imageUrl, required this.onError});

  final String imageUrl;
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
          onDoubleTap: () => PageZoomView.open(context, imageUrl),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: width,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, _) => placeholder(),
                  errorWidget: (context, _, _) {
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
