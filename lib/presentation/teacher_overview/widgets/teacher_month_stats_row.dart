import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/stat_tile.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';

/// Three at-a-glance [StatTile]s on the Teacher Overview: students new this
/// month, active (paid) students, and this month's earnings. Derived only
/// from [teacherOverviewStatsProvider] (no extra backend fields).
class TeacherMonthStatsRow extends ConsumerWidget {
  const TeacherMonthStatsRow({super.key});

  static final NumberFormat _compact = NumberFormat.compact();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (newThisMonth, active, earnedThisMonth) = ref.watch(
      teacherOverviewStatsProvider.select(
        (s) => (s.studentsThisMonth, s.activePaidStudents, s.earningsThisMonth),
      ),
    );
    final studentsLoading = ref.watch(teacherStudentsLoadingProvider);
    final earningsLoading = ref.watch(teacherEarningsLoadingProvider);
    const placeholder = '–';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.tchStatsHeading,
          style: context.textStyles.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: context.dimens.sm),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.person_add_alt_1_rounded,
                  value: studentsLoading ? placeholder : '$newThisMonth',
                  label: context.l10n.tchStatNewThisMonth,
                  color: context.colors.primary,
                ),
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: StatTile(
                  icon: Icons.verified_user_rounded,
                  value: studentsLoading ? placeholder : '$active',
                  label: context.l10n.tchStatActiveStudents,
                  color: context.colors.info,
                ),
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: StatTile(
                  icon: Icons.payments_rounded,
                  value: earningsLoading
                      ? placeholder
                      : _compact.format(earnedThisMonth),
                  label: context.l10n.tchStatEarnedThisMonth,
                  color: context.colors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
