import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart';
import '../viewmodel/teacher_earnings_viewmodel.dart';
import '../widgets/earnings_projected_calculator_card.dart';
import '../widgets/earnings_record_card.dart';

/// Redesigned Teacher Earnings view with actual financial breakdown,
/// motivating projected earnings simulator, and detailed transaction ledger.
class TeacherEarningsView extends ConsumerWidget {
  const TeacherEarningsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(teacherEarningsProvider);
    final stats = ref.watch(teacherOverviewStatsProvider);
    final students = ref.watch(teacherStudentsProvider).value ?? [];
    final studentsById = {for (final s in students) s.id: s.name};

    final currencyFormatter = NumberFormat.currency(
      symbol: 'Rs. ',
      decimalDigits: 0,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          context.l10n.teacherEarningsTitle,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(teacherEarningsProvider);
              ref.invalidate(teacherStudentsProvider);
            },
            child: AsyncValueWidget<List<EarningsRecord>>(
              value: earningsAsync,
              onRetry: () => ref.invalidate(teacherEarningsProvider),
              data: (records) {
                final total = records.fold<double>(
                  0,
                  (sum, record) => sum + record.amount,
                );

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.lg,
                    vertical: context.dimens.sm,
                  ),
                  children: [
                    // 1. Actual Earnings Summary Card (Frosted Glass)
                    AppFrostedCard(
                      padding: EdgeInsets.all(context.dimens.lg),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(context.dimens.md),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF059669,
                              ).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.savings_outlined,
                              color: Color(0xFF059669),
                              size: 28,
                            ),
                          ),
                          SizedBox(width: context.dimens.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.teacherEarningsTotal,
                                  style: context.textStyles.bodySmall?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: context.dimens.xs / 3),
                                Text(
                                  currencyFormatter.format(
                                    total > 0 ? total : stats.actualEarnings,
                                  ),
                                  style: context.textStyles.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF059669),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dimens.sm,
                              vertical: context.dimens.xs,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceVariant
                                  .withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(
                                context.dimens.radiusSm,
                              ),
                            ),
                            child: Text(
                              '${records.length} Purchases',
                              style: context.textStyles.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),

                    // 2. Interactive Projected Earnings Simulator Card
                    EarningsProjectedCalculatorCard(stats: stats),
                    SizedBox(height: context.dimens.xl),

                    // 3. Transactions History Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Commission History',
                          style: context.textStyles.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${records.length} Transactions',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimens.sm),

                    // 4. Records List (Frosted Cards)
                    if (records.isEmpty) ...[
                      EmptyStateView(
                        icon: Icons.account_balance_wallet_outlined,
                        message: context.l10n.teacherEarningsEmpty,
                      ),
                    ] else ...[
                      for (final record in records) ...[
                        Padding(
                          padding: EdgeInsets.only(bottom: context.dimens.sm),
                          child: EarningsRecordCard(
                            record: record,
                            studentName: studentsById[record.studentId],
                          ),
                        ),
                      ],
                    ],
                    SizedBox(height: context.dimens.xl),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
