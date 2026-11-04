import 'package:flutter/material.dart';

import '../../../core/widgets/loading_indicator.dart';
import 'reader_watermark.dart';

/// Full-screen pinch-to-zoom view of a single ebook page, opened on
/// double-tap from the reader. Kept separate from the scrolling pager so the
/// pager's per-page vertical scroll and the `PageView`'s horizontal swipe stay
/// conflict-free (an inline `InteractiveViewer` would fight both). The image
/// is already decoded in memory by the time a page can be double-tapped, so
/// this opens instantly. Takes an [ImageProvider] so it serves both streamed
/// (network) and offline (decrypted-in-memory) pages.
class PageZoomView extends StatelessWidget {
  const PageZoomView({super.key, required this.image});

  final ImageProvider image;

  /// Pushes the zoom view as a transparent overlay route.
  static Future<void> open(BuildContext context, ImageProvider image) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, _, _) => PageZoomView(image: image),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: InteractiveViewer(
              maxScale: 5,
              child: Center(
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                  frameBuilder: (context, child, frame, wasSync) =>
                      frame == null && !wasSync
                          ? const LoadingIndicator()
                          : child,
                  errorBuilder: (context, _, _) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          const Positioned.fill(child: ReaderWatermark()),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
