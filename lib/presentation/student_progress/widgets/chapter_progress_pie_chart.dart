import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../viewmodel/student_progress_viewmodel.dart';

/// Pie chart summarizing weak vs. strong vs. average chapters, aggregated
/// across every attempt the student has submitted (§10.2 Progress tab:
/// "overall progress ... (pie chart)"). Color usage stays semantic per
/// §10.1: `error` for weak, `warning` for average, `success` for strong —
/// the same score-band palette `AttemptCard`'s badge uses.
class ChapterProgressPieChart extends StatelessWidget {
  const ChapterProgressPieChart({super.key, required this.summary});

  final ChapterProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.progressChapterProgressTitle,
            style: context.textStyles.titleMedium,
          ),
          SizedBox(height: context.dimens.md),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 32,
                      sections: [
                        if (summary.weakCount > 0)
                          _section(
                            context,
                            value: summary.weakCount,
                            color: context.colors.error,
                          ),
                        if (summary.averageCount > 0)
                          _section(
                            context,
                            value: summary.averageCount,
                            color: context.colors.warning,
                          ),
                        if (summary.strongCount > 0)
                          _section(
                            context,
                            value: summary.strongCount,
                            color: context.colors.success,
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: context.dimens.lg),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Legend(
                        color: context.colors.error,
                        label: context.l10n.progressSubjectWeakChapters,
                        count: summary.weakCount,
                      ),
                      SizedBox(height: context.dimens.sm),
                      _Legend(
                        color: context.colors.warning,
                        label: context.l10n.progressSubjectAverageChapters,
                        count: summary.averageCount,
                      ),
                      SizedBox(height: context.dimens.sm),
                      _Legend(
                        color: context.colors.success,
                        label: context.l10n.progressSubjectStrongChapters,
                        count: summary.strongCount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(
    BuildContext context, {
    required int value,
    required Color color,
  }) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      radius: 48,
      showTitle: false,
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, required this.count});

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.dimens.sm,
          height: context.dimens.sm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: context.dimens.sm),
        Text(
          '$label ($count)',
          style: context.textStyles.bodyMedium,
        ),
      ],
    );
  }
}
