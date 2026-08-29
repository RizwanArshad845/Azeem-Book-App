import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';

/// Hero visual earnings card on the Teacher Overview tab.
/// Highlights actual commission earned vs projected earning potential based on declared students.
class ProjectedEarningsHeroCard extends StatelessWidget {
  const ProjectedEarningsHeroCard({super.key, required this.stats});

  final TeacherOverviewStats stats;

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = _currencyFormatter;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D5C3A), // Deep Emerald
            Color(0xFF13774D),
            Color(0xFF1E824C),
          ],
        ),
        borderRadius: BorderRadius.circular(context.dimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge + Rate Pill
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
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(
                      context.dimens.radiusLg,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(width: context.dimens.xs / 2),
                      Flexible(
                        child: Text(
                          context.l10n.teacherCommissionAndEarnings,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: context.dimens.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.sm,
                  vertical: context.dimens.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(context.dimens.radiusLg),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Text(
                  context.l10n.teacherPerStudentRate,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),

          // Main Actual Earnings Display
          Text(
            context.l10n.teacherActualEarnings,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.dimens.xs / 2),
          Text(
            currencyFormatter.format(stats.actualEarnings),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: context.dimens.md),

          // Motivating Projected Section Card
          Container(
            padding: EdgeInsets.all(context.dimens.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Colors.amberAccent,
                      size: 20,
                    ),
                    SizedBox(width: context.dimens.xs),
                    Expanded(
                      child: Text(
                        context.l10n.teacherUnlockUpTo(
                          currencyFormatter.format(stats.projectedPotential),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.dimens.xs),
                Text(
                  context.l10n.teacherDeclaredStudentsDesc(
                    stats.declaredStudents,
                    stats.totalStudents,
                    stats.remainingStudents,
                  ),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11.5,
                  ),
                ),
                SizedBox(height: context.dimens.sm),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.dimens.radiusSm),
                  child: LinearProgressIndicator(
                    value: stats.goalProgressPercent,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amberAccent,
                    ),
                  ),
                ),
                SizedBox(height: context.dimens.xs / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        context.l10n.teacherGoalOnboarded(
                          stats.totalStudents,
                          stats.declaredStudents,
                        ),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${(stats.goalProgressPercent * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
