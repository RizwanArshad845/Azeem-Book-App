import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../viewmodel/student_progress_viewmodel.dart';

/// One scannable row for a subject's aggregated progress (§10.1 — cards, not
/// tables) in the Per-Subject filter view. Reuses the shared subject icon
/// vocabulary ([subjectIcon]) so this reads consistently with subject cards
/// elsewhere in the app, and the shared `StatusBadge` for weak/strong chips
/// instead of a one-off pill.
class SubjectProgressCard extends StatelessWidget {
  const SubjectProgressCard({super.key, required this.summary});

  final SubjectProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final score = summary.averageScorePercent.clamp(0, 100).toDouble();
    final scoreColor = score < 50
        ? context.colors.error
        : (score > 75 ? context.colors.success : context.colors.warning);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.dimens.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.primary, context.colors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                ),
                child: Icon(
                  subjectIcon(summary.subjectName),
                  color: context.colors.onPrimary,
                  size: context.dimens.iconMd,
                ),
              ),
              SizedBox(width: context.dimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.subjectName,
                      style: context.textStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      context.l10n.progressSubjectTestsCount(
                        summary.attemptCount,
                      ),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${score.toStringAsFixed(0)}%',
                style: context.textStyles.titleLarge?.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(context.dimens.pillRadius),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 6,
              backgroundColor: context.colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(scoreColor),
            ),
          ),
          if (summary.weakChapterCount > 0 || summary.strongChapterCount > 0) ...[
            SizedBox(height: context.dimens.sm),
            Wrap(
              spacing: context.dimens.sm,
              runSpacing: context.dimens.xs,
              children: [
                if (summary.weakChapterCount > 0)
                  StatusBadge(
                    label:
                        '${summary.weakChapterCount} ${context.l10n.progressSubjectWeakChapters}',
                    color: context.colors.error,
                  ),
                if (summary.strongChapterCount > 0)
                  StatusBadge(
                    label:
                        '${summary.strongChapterCount} ${context.l10n.progressSubjectStrongChapters}',
                    color: context.colors.success,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
