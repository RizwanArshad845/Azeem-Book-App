import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';

final _submittedAtFormat = DateFormat('MMM d, yyyy • h:mm a');

/// One scannable row for a submitted [TestAttempt] (§10.1 — cards, not
/// tables): test title, `scorePercent`, submitted date, and a score-band
/// status badge. [testTitle] is resolved by the caller from
/// `progressTestsByIdProvider` since `TestAttempt` only carries a `testId`.
class AttemptCard extends StatelessWidget {
  const AttemptCard({super.key, required this.attempt, required this.testTitle});

  final TestAttempt attempt;
  final String testTitle;

  @override
  Widget build(BuildContext context) {
    final secondaryStyle = context.textStyles.bodySmall?.copyWith(
      color: context.colors.textSecondary,
    );

    return AppListRow(
      title: testTitle,
      titleStyle: context.textStyles.titleSmall,
      titleMaxLines: 2,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(attempt.scorePercent ?? 0).toStringAsFixed(0)}% score',
            style: secondaryStyle,
          ),
          SizedBox(height: context.dimens.xs / 2),
          Text(_submittedAtFormat.format(attempt.attemptedAt), style: secondaryStyle),
        ],
      ),
      trailing: _ScoreBandBadge(scorePercent: attempt.scorePercent ?? 0),
    );
  }
}

/// Score-band badge using the same thresholds as `computeWeakStrongChapters`
/// (project_spec.md §9.2 note in `compute_weak_strong_chapters.dart`:
/// `< 50%` weak, `> 75%` strong) so this attempt-level badge and the pie
/// chart's chapter-level buckets read as one consistent scale. Built as a
/// thin wrapper around the shared `StatusBadge` (reused, not re-implemented)
/// since `StatusBadge.color` needs a `BuildContext`-resolved semantic color
/// that can't be baked into a `const` factory.
class _ScoreBandBadge extends StatelessWidget {
  const _ScoreBandBadge({required this.scorePercent});

  final double scorePercent;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;
    if (scorePercent < 50) {
      label = 'Weak';
      color = context.colors.error;
    } else if (scorePercent > 75) {
      label = 'Strong';
      color = context.colors.success;
    } else {
      label = 'Average';
      color = context.colors.warning;
    }
    return StatusBadge(label: label, color: color);
  }
}
