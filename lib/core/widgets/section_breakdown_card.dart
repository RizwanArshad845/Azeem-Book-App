import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// One row of the Test Result "Section Breakdown": a tinted chart icon badge, a
/// section title (e.g. "Q1 MCQs"), a correct/wrong sub-line, and an emphasised
/// "earned/total marks • percent" line. Pass several stacked in a column.
class SectionBreakdownCard extends StatelessWidget {
  const SectionBreakdownCard({
    super.key,
    required this.title,
    required this.correct,
    required this.wrong,
    required this.earnedMarks,
    required this.totalMarks,
  });

  final String title;
  final int correct;
  final int wrong;
  final int earnedMarks;
  final int totalMarks;

  @override
  Widget build(BuildContext context) {
    final percent = totalMarks == 0 ? 0 : (earnedMarks / totalMarks * 100).round();
    final color = percent >= 75
        ? context.colors.success
        : percent >= 50
            ? context.colors.warning
            : context.colors.error;

    return AppCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.sm),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: context.colors.success,
              size: context.dimens.iconMd,
            ),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: context.dimens.xs),
                Text(
                  '$correct correct / $wrong wrong',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.dimens.xs),
                Text(
                  '$earnedMarks/$totalMarks marks  •  $percent%',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
