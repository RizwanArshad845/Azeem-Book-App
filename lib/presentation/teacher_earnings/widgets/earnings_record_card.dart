import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../domain/earnings/entities/earnings_record.dart';

/// A single commission line (§10.1 "cards for scannable data, not tables").
/// Deliberately kept to "Commission" + amount + date — resolving the
/// triggering student's name would require a cross-feature dependency on
/// `StudentRepository` this read-only tab doesn't otherwise need (see
/// `teacher_earnings_viewmodel.dart` doc comment).
class EarningsRecordCard extends StatelessWidget {
  const EarningsRecordCard({super.key, required this.record});

  final EarningsRecord record;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return AppListRow(
      leading: Container(
        padding: EdgeInsets.all(context.dimens.sm),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.colors.secondary, context.colors.primary],
          ),
          borderRadius: BorderRadius.circular(context.dimens.radiusMd),
        ),
        child: Icon(
          Icons.payments_outlined,
          color: context.colors.onPrimary,
          size: context.dimens.iconMd,
        ),
      ),
      title: 'Commission',
      subtitle: Text(
        DateFormat('MMM d, yyyy').format(record.createdAt),
        style: context.textStyles.bodySmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
      trailing: Text(
        currency.format(record.amount),
        style: context.textStyles.titleMedium?.copyWith(
          color: context.colors.success,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
