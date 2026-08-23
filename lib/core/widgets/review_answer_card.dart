import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// An expandable per-question row for the "Review Answers" sheet: a coloured
/// status circle, a "QUESTION n • STATUS" overline, the (truncated) question
/// text, a marks chip, and an expand chevron that reveals the correct answer +
/// solution. Purely presentational — the caller supplies already-localized
/// status/label strings.
class ReviewAnswerCard extends StatefulWidget {
  const ReviewAnswerCard({
    super.key,
    required this.index,
    required this.isCorrect,
    required this.statusLabel,
    required this.questionText,
    required this.scoreLabel,
    this.correctAnswerLabel,
    this.correctAnswer,
    this.solutionLabel,
    this.solution,
  });

  final int index;
  final bool isCorrect;
  final String statusLabel;
  final String questionText;
  final String scoreLabel;
  final String? correctAnswerLabel;
  final String? correctAnswer;
  final String? solutionLabel;
  final String? solution;

  @override
  State<ReviewAnswerCard> createState() => _ReviewAnswerCardState();
}

class _ReviewAnswerCardState extends State<ReviewAnswerCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isCorrect ? context.colors.success : context.colors.error;
    final hasDetail = (widget.correctAnswer?.isNotEmpty ?? false) ||
        (widget.solution?.isNotEmpty ?? false);

    return AppCard(
      onTap: hasDetail ? () => setState(() => _expanded = !_expanded) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.isCorrect ? Icons.check_circle : Icons.cancel,
                color: color,
                size: context.dimens.iconLg,
              ),
              SizedBox(width: context.dimens.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.reviewQuestionOverline(
                        widget.index,
                        widget.statusLabel.toUpperCase(),
                      ),
                      style: context.textStyles.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: context.dimens.xs),
                    Text(
                      widget.questionText,
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.dimens.sm),
              _ScoreChip(label: widget.scoreLabel, color: color),
              if (hasDetail)
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: context.colors.textSecondary,
                ),
            ],
          ),
          if (_expanded && hasDetail) ...[
            SizedBox(height: context.dimens.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.dimens.sm + 2),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(context.dimens.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.correctAnswer?.isNotEmpty ?? false) ...[
                    _detail(
                      context,
                      widget.correctAnswerLabel ?? context.l10n.reviewCorrectAnswerLabel,
                      widget.correctAnswer!,
                    ),
                  ],
                  if ((widget.correctAnswer?.isNotEmpty ?? false) &&
                      (widget.solution?.isNotEmpty ?? false))
                    SizedBox(height: context.dimens.sm),
                  if (widget.solution?.isNotEmpty ?? false)
                    _detail(
                      context,
                      widget.solutionLabel ?? context.l10n.testResultsSolutionLabel,
                      widget.solution!,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detail(BuildContext context, String? label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label,
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        Text(value, style: context.textStyles.bodySmall),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.sm,
        vertical: context.dimens.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.dimens.radiusSm),
      ),
      child: Text(
        label,
        style: context.textStyles.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
