import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/skeleton.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';

/// Hero visual earnings card on the Teacher Overview tab.
/// Highlights actual commission earned vs projected earning potential based on declared students.
///
/// Watches only the earnings-related fields of [TeacherOverviewStats] so this
/// card doesn't rebuild when unrelated fields (e.g. activePaidStudents) change.
class ProjectedEarningsHeroCard extends ConsumerWidget {
  const ProjectedEarningsHeroCard({super.key});

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      actualEarnings,
      projectedPotential,
      declaredStudents,
      totalStudents,
      remainingStudents,
      goalProgressPercent,
    ) = ref.watch(
      teacherOverviewStatsProvider.select(
        (s) => (
          s.actualEarnings,
          s.projectedPotential,
          s.declaredStudents,
          s.totalStudents,
          s.remainingStudents,
          s.goalProgressPercent,
        ),
      ),
    );
    final earningsLoading = ref.watch(teacherEarningsLoadingProvider);
    final studentsLoading = ref.watch(teacherStudentsLoadingProvider);
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
          earningsLoading
              ? const Skeleton(width: 140, height: 32)
              : Text(
                  currencyFormatter.format(actualEarnings),
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
              children: studentsLoading
                  ? [
                      const Skeleton(width: 220, height: 14),
                      SizedBox(height: context.dimens.sm),
                      const Skeleton(width: double.infinity, height: 11.5),
                      SizedBox(height: context.dimens.sm),
                      Skeleton(
                        width: double.infinity,
                        height: 6,
                        radius: context.dimens.radiusSm,
                      ),
                      SizedBox(height: context.dimens.xs / 2),
                      const Skeleton(width: 140, height: 11),
                    ]
                  : [
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
                          currencyFormatter.format(projectedPotential),
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
                    declaredStudents,
                    totalStudents,
                    remainingStudents,
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
                    value: goalProgressPercent,
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
                          totalStudents,
                          declaredStudents,
                        ),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${(goalProgressPercent * 100).toInt()}%',
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
