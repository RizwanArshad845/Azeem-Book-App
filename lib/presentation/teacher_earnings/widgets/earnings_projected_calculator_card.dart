import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';

/// Interactive Projected Earnings card highlighting current commission vs.
/// potential earnings as more declared students purchase test packs.
///
/// Takes the two primitives it actually uses rather than the whole
/// `TeacherOverviewStats` object, so callers can `.select` just these fields
/// from Riverpod instead of watching the entire stats provider.
class EarningsProjectedCalculatorCard extends StatefulWidget {
  const EarningsProjectedCalculatorCard({
    super.key,
    required this.actualEarnings,
    required this.remainingStudents,
  });

  final double actualEarnings;
  final int remainingStudents;

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
    _simulatedAdditionalStudents =
        widget.remainingStudents.toDouble().clamp(0.0, 100.0);
  }

  @override
  void didUpdateWidget(covariant EarningsProjectedCalculatorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingStudents != widget.remainingStudents) {
      _simulatedAdditionalStudents =
          widget.remainingStudents.toDouble().clamp(0.0, 100.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = _currency;
    final simulatedCommission = _simulatedAdditionalStudents * 500.0;
    final totalSimulated = widget.actualEarnings + simulatedCommission;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E293B), // Deep slate
            const Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.circular(context.dimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.sm,
                  vertical: context.dimens.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(context.dimens.radiusLg),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_graph_rounded,
                      color: Colors.amberAccent,
                      size: 15,
                    ),
                    SizedBox(width: context.dimens.xs / 2),
                    Text(
                      context.l10n.teacherProjectedSimulatorTitle,
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                context.l10n.teacherPerPackRate,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),

          // Total Potential Number
          Text(
            context.l10n.teacherTotalProjectedEarnings,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12.5,
            ),
          ),
          SizedBox(height: context.dimens.xs / 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currency.format(totalSimulated),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: context.dimens.xs),
              Text(
                '(+${currency.format(simulatedCommission)})',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 14,
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
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          SizedBox(height: context.dimens.xs),

          // Interactive Simulation Slider
          if (widget.remainingStudents > 0) ...[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.amberAccent,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                thumbColor: Colors.amber,
                overlayColor: Colors.amber.withValues(alpha: 0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: _simulatedAdditionalStudents,
                min: 0,
                max: (widget.remainingStudents > 0
                        ? widget.remainingStudents
                        : 50)
                    .toDouble(),
                divisions: (widget.remainingStudents > 0
                        ? widget.remainingStudents
                        : 50)
                    .clamp(1, 100),
                onChanged: (val) {
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
                  style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                ),
                Text(
                  context.l10n.teacherAllRemainingStudents(
                    widget.remainingStudents,
                  ),
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(context.dimens.sm),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(context.dimens.radiusSm),
              ),
              child: Text(
                context.l10n.teacherGoalReachedMessage,
                style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
