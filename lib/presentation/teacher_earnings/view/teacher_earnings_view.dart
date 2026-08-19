import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/stat_summary_card.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../viewmodel/teacher_earnings_viewmodel.dart';
import '../widgets/earnings_record_card.dart';

/// Teacher shell Earnings tab root (§10.2 "Detailed Earnings Dashboard") —
/// the dedicated transaction-level breakdown behind the two summary numbers
/// already shown on the Overview tab. Purely read-only (no primary action):
/// every `EarningsRecord` is created as a side effect of a student's
/// checkout, never from here (§10.1's "one primary action per screen" rule
/// doesn't force a button where the tab's whole purpose is at-a-glance
/// history, mirrors `TeacherOverviewView`).
class TeacherEarningsView extends ConsumerWidget {
  const TeacherEarningsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(teacherEarningsProvider);

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

            final total = records.fold<double>(
              0,
              (sum, record) => sum + record.amount,
            );

            return ListView(
              padding: EdgeInsets.all(context.dimens.lg),
              children: [
                StatSummaryCard(
                  icon: Icons.account_balance_wallet_outlined,
                  label: context.l10n.teacherEarningsTotal,
                  value: NumberFormat.currency(
                    symbol: 'Rs. ',
                    decimalDigits: 0,
                  ).format(total),
                  valueStyle: context.textStyles.headlineSmall,
                  subtitle: context.l10n.teacherEarningsTransactionCount(records.length),
                ),
                SizedBox(height: context.dimens.lg),
                ...records
                    .map(
                      (record) => Padding(
                        padding: EdgeInsets.only(bottom: context.dimens.sm),
                        child: EarningsRecordCard(record: record),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
