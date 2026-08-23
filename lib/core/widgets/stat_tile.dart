import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// A compact square stat tile: a tinted icon badge, a large value, and a label
/// underneath. Used in the Test Result 3-up stats row (Correct / Wrong / Time).
/// Wrap several in a [Row] of [Expanded]s for the reference layout.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(context.dimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            ),
            child: Icon(icon, color: color, size: context.dimens.iconMd),
          ),
          SizedBox(height: context.dimens.sm),
          Text(
            value,
            style: context.textStyles.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
