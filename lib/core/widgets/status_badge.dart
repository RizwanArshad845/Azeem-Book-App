import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Small pill badge for scannable status flags on an `AppCard` — "Free",
/// "Live", "Registered" — shared across the app instead of each feature
/// inventing its own badge chip.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.color});

  /// Convenience constructor for the "Live" badge — always semantic
  /// `context.colors.warning`.
  const StatusBadge.live({super.key})
    : label = 'Live',
      color = null;

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.warning;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.sm,
        vertical: context.dimens.xs / 2,
      ),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.dimens.pillRadius),
      ),
      child: Text(
        label,
        style: context.textStyles.labelSmall?.copyWith(color: effectiveColor),
      ),
    );
  }
}
