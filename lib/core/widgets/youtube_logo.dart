import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// YouTube-style play badge (rounded red "screen" with a white play glyph),
/// drawn natively so no brand image asset is bundled. Width is 1.42× [height],
/// matching the real logo's proportions.
class YoutubeLogo extends StatelessWidget {
  const YoutubeLogo({super.key, this.height = 48});

  final double height;

  @override
  Widget build(BuildContext context) {
    final red = context.colors.youtubeRed;
    return Container(
      width: height * 1.42,
      height: height,
      decoration: BoxDecoration(
        color: red,
        borderRadius: BorderRadius.circular(height * 0.28),
        boxShadow: [
          BoxShadow(
            color: red.withValues(alpha: 0.35),
            blurRadius: height * 0.3,
            offset: Offset(0, height * 0.08),
          ),
        ],
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: context.colors.onPrimary,
        size: height * 0.75,
      ),
    );
  }
}
