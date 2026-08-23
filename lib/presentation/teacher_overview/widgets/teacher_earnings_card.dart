import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/stat_summary_card.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';

class TeacherEarningsCard extends StatelessWidget {
  const TeacherEarningsCard({super.key, required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);
    final projected = teacher.projectedEarnings;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatSummaryCard(
            wrapInCard: false,
            useGradientIconBadge: true,
            icon: Icons.account_balance_wallet_outlined,
            iconColor: context.colors.secondary,
            label: context.l10n.teacherOverviewActualEarnings,
            value: currency.format(teacher.actualEarnings),
          ),
          SizedBox(height: context.dimens.lg),
          Divider(color: context.colors.divider, height: 1),
          SizedBox(height: context.dimens.lg),
          StatSummaryCard(
            wrapInCard: false,
            useGradientIconBadge: true,
            icon: Icons.hourglass_top_outlined,
            iconColor: context.colors.textSecondary,
            label: context.l10n.teacherOverviewProjectedEarnings,
            value: projected != null
                ? currency.format(projected)
                : context.l10n.teacherOverviewNotAvailable,
            valueStyle: projected == null
                ? context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
