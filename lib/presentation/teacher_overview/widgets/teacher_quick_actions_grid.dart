import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';

/// Quick interactive shortcut action cards on the Teacher Overview dashboard.
class TeacherQuickActionsGrid extends StatelessWidget {
  const TeacherQuickActionsGrid({super.key, required this.stats});

  final TeacherOverviewStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.teacherQuickActions,
          style: context.textStyles.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: context.dimens.sm),
        Row(
          children: [
            // Action 1: Students Roster
            Expanded(
              child: _ActionTile(
                icon: Icons.groups_rounded,
                iconColor: context.colors.primary,
                bgColor: context.colors.primary.withValues(alpha: 0.1),
                title: context.l10n.teacherStudentsRoster(stats.totalStudents),
                subtitle: context.l10n.teacherStudentsRosterSub(
                  stats.activePaidStudents,
                  stats.freeStudents,
                ),
                onTap: () => context.go(AppRoutes.teacherStudents),
              ),
            ),
            SizedBox(width: context.dimens.sm),

            // Action 2: Earnings Breakdown
            Expanded(
              child: _ActionTile(
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF059669), // Emerald
                bgColor: const Color(0xFF059669).withValues(alpha: 0.1),
                title: context.l10n.teacherEarningsLedger,
                subtitle: context.l10n.teacherEarningsLedgerSub,
                onTap: () => context.go(AppRoutes.teacherEarnings),
              ),
            ),
          ],
        ),
        SizedBox(height: context.dimens.sm),
        Row(
          children: [
            // Action 3: Create Custom Test (Phase 2 preview)
            Expanded(
              child: _ActionTile(
                icon: Icons.note_add_rounded,
                iconColor: const Color(0xFF7C3AED), // Purple
                bgColor: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                title: context.l10n.teacherCustomTest,
                subtitle: context.l10n.teacherCustomTestSub,
                badgeText: context.l10n.commonPhase2Badge,
                onTap: () {
                  AppSnackbar.show(
                    context,
                    context.l10n.teacherCustomTestPhase2Message,
                  );
                },
              ),
            ),
            SizedBox(width: context.dimens.sm),

            // Action 4: Share Teacher Code / Link
            Expanded(
              child: _ActionTile(
                icon: Icons.share_rounded,
                iconColor: const Color(0xFFD97706), // Amber
                bgColor: const Color(0xFFD97706).withValues(alpha: 0.1),
                title: context.l10n.teacherShareReferral,
                subtitle: context.l10n.teacherShareReferralSub,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: context.l10n.teacherReferralShareText),
                  );
                  AppSnackbar.show(
                    context,
                    context.l10n.teacherReferralLinkCopied,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String? badgeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppFrostedCard(
      onTap: onTap,
      padding: EdgeInsets.all(context.dimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(context.dimens.xs * 1.5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(
                    context.dimens.radiusSm,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (badgeText != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.xs,
                    vertical: context.dimens.xs / 3,
                  ),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(
                      context.dimens.radiusSm,
                    ),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.textSecondary.withValues(
                    alpha: 0.5,
                  ),
                  size: 20,
                ),
            ],
          ),
          SizedBox(height: context.dimens.sm),
          Text(
            title,
            style: context.textStyles.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.dimens.xs / 3),
          Text(
            subtitle,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
