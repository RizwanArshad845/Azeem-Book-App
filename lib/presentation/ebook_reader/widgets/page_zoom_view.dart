import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/loading_indicator.dart';

/// Full-screen pinch-to-zoom view of a single ebook page, opened on
/// double-tap from the reader. Kept separate from the scrolling pager so the
/// pager's per-page vertical scroll and the `PageView`'s horizontal swipe stay
/// conflict-free (an inline `InteractiveViewer` would fight both). The image
/// is already in the cache by the time a page can be double-tapped, so this
/// opens instantly.
class PageZoomView extends StatelessWidget {
  const PageZoomView({super.key, required this.imageUrl});

  final String imageUrl;

  /// Pushes the zoom view as a transparent overlay route.
  static Future<void> open(BuildContext context, String imageUrl) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, _, _) => PageZoomView(imageUrl: imageUrl),
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
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, _) => const LoadingIndicator(),
                  errorWidget: (context, _, _) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
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
