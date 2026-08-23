import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// A single item in a [MetaRow] — an optional leading icon + a label, with an
/// optional emphasis colour (e.g. amber "Unlock", green "Free").
class MetaItem {
  const MetaItem(this.label, {this.icon, this.color});

  final String label;
  final IconData? icon;
  final Color? color;
}

/// Renders a compact metadata line like `98 ques | 134 min | 🔒 Unlock`, with
/// thin dividers between items. Used on test cards (and anywhere a scannable
/// stat strip is needed). Wraps to a second line gracefully on narrow widths.
class MetaRow extends StatelessWidget {
  const MetaRow(this.items, {super.key});

  final List<MetaItem> items;

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textStyles.bodySmall?.copyWith(
      color: context.colors.textSecondary,
    );
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.dimens.xs + 2),
            child: Text('|', style: baseStyle?.copyWith(color: context.colors.divider)),
          ),
        );
      }
      final item = items[i];
      final color = item.color ?? context.colors.textSecondary;
      children.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, size: context.dimens.iconSm - 2, color: color),
              SizedBox(width: context.dimens.xs),
            ],
            Text(
              item.label,
              style: baseStyle?.copyWith(
                color: color,
                fontWeight: item.color != null ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: context.dimens.xs,
      children: children,
    );
  }
}
