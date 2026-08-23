import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/stat_summary_card.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';
import '../../teacher_overview/widgets/teacher_earnings_card.dart';
import '../viewmodel/teacher_earnings_viewmodel.dart';
import '../widgets/earnings_record_card.dart';

/// Teacher shell Earnings tab root (§10.2 "Detailed Earnings Dashboard") —
/// the dedicated transaction-level breakdown behind the two summary numbers
/// already shown on the Overview tab. Purely read-only (no primary action):
/// every `EarningsRecord` is created as a side effect of a student's
/// checkout, never from here (§10.1's "one primary action per screen" rule
/// doesn't force a button where the tab's whole purpose is at-a-glance
/// history, mirrors `TeacherOverviewView`).
///
/// Redesigned per CLAUDE.md's "creative card layout, projected revenue
/// metrics": a hero total (gradient icon badge), the existing
/// `TeacherEarningsCard` reused as-is for the actual-vs-projected split
/// (avoids duplicating that comparison a second way), then a "Commission
/// breakdown" section grouping the transaction list by `triggerEvent`
/// (currently a single value, `paidPackPurchase`, but grouped generically so
/// a future trigger event doesn't need a layout rewrite).
class TeacherEarningsView extends ConsumerWidget {
  const TeacherEarningsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(teacherEarningsProvider);
    final teacher = ref.watch(currentTeacherProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.teacherEarningsTitle)),
      body: SafeArea(
        child: AsyncValueWidget<List<EarningsRecord>>(
          value: earningsAsync,
          onRetry: () => ref.invalidate(teacherEarningsProvider),
          data: (records) {
            if (records.isEmpty) {
              return EmptyStateView(
                icon: Icons.account_balance_wallet_outlined,
                message: context.l10n.teacherEarningsEmpty,
              );
            }

            final currency = NumberFormat.currency(
              symbol: 'Rs. ',
              decimalDigits: 0,
            );
            final total = records.fold<double>(
              0,
              (sum, record) => sum + record.amount,
            );

            final grouped = <EarningsTriggerEvent, List<EarningsRecord>>{};
            for (final record in records) {
              grouped.putIfAbsent(record.triggerEvent, () => []).add(record);
            }

            return ListView(
              padding: EdgeInsets.all(context.dimens.lg),
              children: [
                StatSummaryCard(
                  icon: Icons.account_balance_wallet_outlined,
                  useGradientIconBadge: true,
                  label: context.l10n.teacherEarningsTotal,
                  value: currency.format(total),
                  valueStyle: context.textStyles.headlineSmall,
                  subtitle: context.l10n.teacherEarningsTransactionCount(records.length),
                ),
                if (teacher != null) ...[
                  SizedBox(height: context.dimens.lg),
                  TeacherEarningsCard(teacher: teacher),
                ],
                SizedBox(height: context.dimens.xl),
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: context.dimens.iconSm,
                      color: context.colors.textSecondary,
                    ),
                    SizedBox(width: context.dimens.sm),
                    Text(
                      context.l10n.teacherEarningsBreakdownTitle,
                      style: context.textStyles.titleMedium,
                    ),
                  ],
                ),
                SizedBox(height: context.dimens.md),
                for (final entry in grouped.entries) ...[
                  Text(
                    _triggerEventLabel(context, entry.key),
                    style: context.textStyles.labelLarge?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.dimens.sm),
                  ...entry.value.map(
                    (record) => Padding(
                      padding: EdgeInsets.only(bottom: context.dimens.sm),
                      child: EarningsRecordCard(record: record),
                    ),
                  ),
                  SizedBox(height: context.dimens.sm),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

String _triggerEventLabel(BuildContext context, EarningsTriggerEvent event) {
  switch (event) {
    case EarningsTriggerEvent.paidPackPurchase:
      return context.l10n.teacherEarningsTriggerPaidPackPurchase;
  }
}
