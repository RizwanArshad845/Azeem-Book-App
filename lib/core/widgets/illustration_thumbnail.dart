import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// A rounded square thumbnail that shows an illustration asset when present and
/// falls back to a native icon in a brand-gradient badge when the asset path is
/// null or the file is missing. This is the single place the "illustration with
/// icon fallback" rule (CLAUDE.md §Student Class & Subject) is implemented.
class IllustrationThumbnail extends StatelessWidget {
  const IllustrationThumbnail({
    super.key,
    required this.fallbackIcon,
    this.imageAsset,
    this.size = 64,
    this.cornerBadge,
  });

  final IconData fallbackIcon;
  final String? imageAsset;
  final double size;

  /// Optional small overlay (e.g. a check badge) pinned to the bottom-right.
  final Widget? cornerBadge;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.dimens.radiusMd);
    final Widget content = imageAsset == null
        ? _iconBadge(context, radius)
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: radius,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _iconBadge(context, radius),
            ),
          );

    if (cornerBadge == null) return content;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        content,
        Positioned(bottom: -2, right: -2, child: cornerBadge!),
      ],
    );
  }

  Widget _iconBadge(BuildContext context, BorderRadius radius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: context.colors.brandGradient,
        borderRadius: radius,
      ),
      child: Icon(
        fallbackIcon,
        color: context.colors.onPrimary,
        size: size * 0.46,
      ),
    );
  }
}
