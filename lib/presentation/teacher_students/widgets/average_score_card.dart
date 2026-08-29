import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';

class AverageScoreCard extends StatelessWidget {
  const AverageScoreCard({
    super.key,
    required this.averagePercent,
    required this.attemptCount,
  });

  final double averagePercent;
  final int attemptCount;

  @override
  Widget build(BuildContext context) {
    final isGood = averagePercent >= 75;
    final scoreColor =
        isGood ? const Color(0xFF059669) : context.colors.primary;

    return AppFrostedCard(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.md),
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_outlined,
              color: scoreColor,
              size: 28,
            ),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.averageScoreLabel,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.dimens.xs / 3),
                Text(
                  context.l10n.testsAttemptedCount(attemptCount),
                  style: context.textStyles.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${averagePercent.toStringAsFixed(0)}%',
            style: context.textStyles.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}
