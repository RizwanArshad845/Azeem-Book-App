import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';

/// Interactive Projected Earnings card highlighting current commission vs.
/// potential earnings as more declared students purchase test packs.
class EarningsProjectedCalculatorCard extends StatefulWidget {
  const EarningsProjectedCalculatorCard({super.key, required this.stats});

  final TeacherOverviewStats stats;

  @override
  State<EarningsProjectedCalculatorCard> createState() =>
      _EarningsProjectedCalculatorCardState();
}

class _EarningsProjectedCalculatorCardState
    extends State<EarningsProjectedCalculatorCard> {
  late double _simulatedAdditionalStudents;

  @override
  void initState() {
    super.initState();
    _simulatedAdditionalStudents =
        widget.stats.remainingStudents.toDouble().clamp(0.0, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);
    final simulatedCommission = _simulatedAdditionalStudents * 500.0;
    final totalSimulated = widget.stats.actualEarnings + simulatedCommission;

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
                    const Text(
                      'Projected Earnings Simulator',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Rs. 500/pack',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),

          // Total Potential Number
          Text(
            'Total Projected Earnings',
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
            'If ${_simulatedAdditionalStudents.toInt()} more of your remaining declared students buy a test pack:',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          SizedBox(height: context.dimens.xs),

          // Interactive Simulation Slider
          if (widget.stats.remainingStudents > 0) ...[
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
                max: (widget.stats.remainingStudents > 0
                        ? widget.stats.remainingStudents
                        : 50)
                    .toDouble(),
                divisions: (widget.stats.remainingStudents > 0
                        ? widget.stats.remainingStudents
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
                const Text(
                  '0 Students',
                  style: TextStyle(color: Colors.white54, fontSize: 10.5),
                ),
                Text(
                  'All ${widget.stats.remainingStudents} Remaining Students',
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
              child: const Text(
                '🎉 Goal reached! All declared students are currently onboarded.',
                style: TextStyle(color: Colors.amberAccent, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
