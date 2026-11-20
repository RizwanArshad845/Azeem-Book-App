import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';

/// Interactive Projected Earnings card highlighting current commission vs.
/// potential earnings as more declared students purchase test packs, plus
/// the declared-students goal progress. This is the single home for
/// projected earnings — the Overview tab only links here.
///
/// Takes the primitives it actually uses rather than the whole
/// `TeacherOverviewStats` object, so callers can `.select` just these fields
/// from Riverpod instead of watching the entire stats provider.
class EarningsProjectedCalculatorCard extends StatefulWidget {
  const EarningsProjectedCalculatorCard({
    super.key,
    required this.actualEarnings,
    required this.remainingStudents,
    required this.declaredStudents,
    required this.onboardedStudents,
    required this.goalProgress,
  });

  final double actualEarnings;
  final int remainingStudents;
  final int declaredStudents;
  final int onboardedStudents;

  /// 0..1 share of declared students already onboarded.
  final double goalProgress;

  @override
  State<EarningsProjectedCalculatorCard> createState() =>
      _EarningsProjectedCalculatorCardState();
}

class _EarningsProjectedCalculatorCardState
    extends State<EarningsProjectedCalculatorCard> {
  static final NumberFormat _currency = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  late double _simulatedAdditionalStudents;

  @override
  void initState() {
    super.initState();
    _simulatedAdditionalStudents = widget.remainingStudents.toDouble().clamp(
      0.0,
      100.0,
    );
  }

  @override
  void didUpdateWidget(covariant EarningsProjectedCalculatorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingStudents != widget.remainingStudents) {
      _simulatedAdditionalStudents = widget.remainingStudents.toDouble().clamp(
        0.0,
        100.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final onCard = colors.onPrimary;
    final highlight = colors.secondary;
    final muted = onCard.withValues(alpha: 0.8);

    final currency = _currency;
    final simulatedCommission = _simulatedAdditionalStudents * 500.0;
    final totalSimulated = widget.actualEarnings + simulatedCommission;

    return Container(
      decoration: BoxDecoration(
        gradient: colors.earningsGradient,
        borderRadius: BorderRadius.circular(context.dimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.28),
            blurRadius: context.dimens.lg,
            offset: Offset(0, context.dimens.sm),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.sm,
                    vertical: context.dimens.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: highlight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      context.dimens.pillRadius,
                    ),
                    border: Border.all(color: highlight.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_graph_rounded,
                        color: highlight,
                        size: context.dimens.iconSm,
                      ),
                      SizedBox(width: context.dimens.xs / 2),
                      Flexible(
                        child: Text(
                          context.l10n.teacherProjectedSimulatorTitle,
                          style: text.labelSmall?.copyWith(
                            color: highlight,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: context.dimens.xs),
              Text(
                context.l10n.teacherPerPackRate,
                style: text.labelSmall?.copyWith(color: muted),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),

          // Total Potential Number
          Text(
            context.l10n.teacherTotalProjectedEarnings,
            style: text.bodySmall?.copyWith(color: muted),
          ),
          SizedBox(height: context.dimens.xs / 2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: context.dimens.xs,
            children: [
              Text(
                currency.format(totalSimulated),
                style: text.headlineMedium?.copyWith(
                  color: onCard,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(+${currency.format(simulatedCommission)})',
                style: text.bodyMedium?.copyWith(
                  color: highlight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.sm),
          Text(
            context.l10n.teacherSimulatorPrompt(
              _simulatedAdditionalStudents.toInt(),
            ),
            style: text.bodySmall?.copyWith(color: muted),
          ),
          SizedBox(height: context.dimens.xs),

          // Interactive Simulation Slider
          if (widget.remainingStudents > 0) ...[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: highlight,
                inactiveTrackColor: onCard.withValues(alpha: 0.2),
                thumbColor: highlight,
                overlayColor: highlight.withValues(alpha: 0.2),
                trackHeight: context.dimens.xs,
              ),
              child: Slider(
                value: _simulatedAdditionalStudents,
                min: 0,
                max: widget.remainingStudents.toDouble(),
                divisions: widget.remainingStudents.clamp(1, 100),
                onChanged: (val) {
                  // Ephemeral slider position only — not business state.
                  setState(() {
                    _simulatedAdditionalStudents = val;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.teacherZeroStudentsLabel,
                  style: text.labelSmall?.copyWith(
                    color: onCard.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  context.l10n.teacherAllRemainingStudents(
                    widget.remainingStudents,
                  ),
                  style: text.labelSmall?.copyWith(
                    color: highlight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(context.dimens.sm),
              decoration: BoxDecoration(
                color: onCard.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(context.dimens.radiusSm),
              ),
              child: Text(
                context.l10n.teacherGoalReachedMessage,
                style: text.bodySmall?.copyWith(color: highlight),
              ),
            ),
          ],

          // Declared-students goal progress (moved here from the Overview
          // hero so all projection info lives on this one card).
          if (widget.declaredStudents > 0) ...[
            SizedBox(height: context.dimens.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(context.dimens.radiusSm),
              child: LinearProgressIndicator(
                value: widget.goalProgress,
                minHeight: context.dimens.xs * 1.5,
                backgroundColor: onCard.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(highlight),
              ),
            ),
            SizedBox(height: context.dimens.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    context.l10n.teacherGoalOnboarded(
                      widget.onboardedStudents,
                      widget.declaredStudents,
                    ),
                    style: text.labelSmall?.copyWith(color: muted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${(widget.goalProgress * 100).toInt()}%',
                  style: text.labelSmall?.copyWith(
                    color: highlight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
