import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// Shared scaffold for a scannable entity-list row (§10.1 — cards, not
/// tables): optional leading icon, a title, an optional subtitle slot (free
/// form — a single `Text`, a multi-line `Column`, or a styled `Row`), and an
/// optional trailing widget (icon, badge, button, amount). Wraps `AppCard`.
class AppListRow extends StatelessWidget {
  const AppListRow({
    super.key,
    required this.title,
    this.titleStyle,
    this.titleMaxLines,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final TextStyle? titleStyle;

  /// Leave `null` for unconstrained wrapping (the original per-view default
  /// unless that view explicitly truncated).
  final int? titleMaxLines;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: context.dimens.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ?? context.textStyles.bodyLarge,
                  maxLines: titleMaxLines,
                  overflow: titleMaxLines != null
                      ? TextOverflow.ellipsis
                      : null,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: context.dimens.xs / 2),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: context.dimens.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
