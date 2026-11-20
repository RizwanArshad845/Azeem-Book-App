import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../domain/earnings/entities/earnings_record.dart';

/// Scannable commission transaction row with student attribution and amount badge.
class EarningsRecordCard extends StatelessWidget {
  const EarningsRecordCard({super.key, required this.record, this.studentName});

  final EarningsRecord record;
  final String? studentName;

  static final NumberFormat _currency = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final currency = _currency;

    return AppFrostedCard(
      padding: EdgeInsets.all(context.dimens.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.sm),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: context.colors.success,
              size: context.dimens.iconMd,
            ),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName != null
                      ? context.l10n.teacherEarningsRecordSubtitle(studentName!)
                      : context.l10n.teacherStudentPackPurchaseFallback,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.dimens.xs / 3),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(record.createdAt),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.sm,
              vertical: context.dimens.xs / 2,
            ),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusSm),
            ),
            child: Text(
              '+${currency.format(record.amount)}',
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
