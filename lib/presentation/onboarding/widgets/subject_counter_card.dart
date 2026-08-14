import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Interactive counter widget for selecting number of subjects
class SubjectCounterCard extends StatelessWidget {
  const SubjectCounterCard({
    super.key,
    required this.count,
    required this.minCount,
    required this.maxCount,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int count;
  final int minCount;
  final int maxCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimens.lg, vertical: dimens.lg),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(dimens.radiusLg),
        border: Border.all(color: colors.divider, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decrement Button
          IconButton.filled(
            onPressed: count > minCount ? onDecrement : null,
            icon: const Icon(Icons.remove_rounded),
            style: IconButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              disabledBackgroundColor: colors.divider,
            ),
          ),

          // Animated Number Counter Display
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimens.xl),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Text(
                '$count',
                key: ValueKey(count),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
          ),

          // Increment Button
          IconButton.filled(
            onPressed: count < maxCount ? onIncrement : null,
            icon: const Icon(Icons.add_rounded),
            style: IconButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              disabledBackgroundColor: colors.divider,
            ),
          ),
        ],
      ),
    );
  }
}
