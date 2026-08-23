import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';
import 'illustration_thumbnail.dart';

/// A horizontal card with a left illustration thumbnail (image + icon
/// fallback), a title, an optional meta line, an optional top badge, and a
/// trailing chevron. The shared base for test cards and course/subject cards
/// (Round-2 "courses_reference" / test-list look). Composes [AppCard] so it
/// inherits the press-scale + surface styling automatically.
class IllustratedListCard extends StatelessWidget {
  const IllustratedListCard({
    super.key,
    required this.title,
    required this.fallbackIcon,
    this.imageAsset,
    this.meta,
    this.badge,
    this.trailing,
    this.cornerBadge,
    this.titleMaxLines = 2,
    this.thumbnailSize = 64,
    this.onTap,
  });

  final String title;
  final IconData fallbackIcon;
  final String? imageAsset;

  /// Sub-line under the title (e.g. a [MetaRow]).
  final Widget? meta;

  /// Optional status badge shown at the top-right of the text column.
  final Widget? badge;

  /// Trailing widget; defaults to a chevron when [onTap] is set.
  final Widget? trailing;

  /// Optional overlay pinned to the thumbnail's corner (e.g. a check badge).
  final Widget? cornerBadge;

  final int titleMaxLines;
  final double thumbnailSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveTrailing = trailing ??
        (onTap != null
            ? Icon(Icons.chevron_right, color: context.colors.textSecondary)
            : null);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(context.dimens.sm + 4),
      child: Row(
        children: [
          IllustrationThumbnail(
            fallbackIcon: fallbackIcon,
            imageAsset: imageAsset,
            size: thumbnailSize,
            cornerBadge: cornerBadge,
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (badge != null) ...[
                      SizedBox(width: context.dimens.sm),
                      badge!,
                    ],
                  ],
                ),
                if (meta != null) ...[
                  SizedBox(height: context.dimens.xs + 2),
                  meta!,
                ],
              ],
            ),
          ),
          if (effectiveTrailing != null) ...[
            SizedBox(width: context.dimens.xs),
            effectiveTrailing,
          ],
        ],
      ),
    );
  }
}
