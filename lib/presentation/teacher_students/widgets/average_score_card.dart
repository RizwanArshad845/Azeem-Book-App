import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/stat_summary_card.dart';

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
    return StatSummaryCard(
      trailingValue: true,
      label: context.l10n.averageScoreLabel,
      subtitle: context.l10n.testsAttemptedCount(attemptCount),
      value: '${averagePercent.toStringAsFixed(0)}%',
    );
  }
}
