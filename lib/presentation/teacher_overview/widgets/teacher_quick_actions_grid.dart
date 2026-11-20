import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/app_snackbar.dart';

/// Overview shortcuts that are NOT already one tap away in the bottom nav:
/// a compact link into the Earnings tab's projected-earnings simulator
/// (projected figures live only there) and the referral invite.
///
/// Roster/Ledger shortcuts were dropped — they duplicated the Students and
/// Earnings tabs.
class TeacherQuickActionsGrid extends StatelessWidget {
  const TeacherQuickActionsGrid({super.key});

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
        _ActionRow(
          icon: Icons.trending_up_rounded,
          color: context.colors.success,
          title: context.l10n.tchEarningsLinkTitle,
          subtitle: context.l10n.tchEarningsLinkSub,
          onTap: () => context.go(AppRoutes.teacherEarnings),
        ),
        SizedBox(height: context.dimens.sm),
        // No share_plus dependency in pubspec — copy the invite text and
        // confirm with a snackbar instead of a native share sheet.
        _ActionRow(
          icon: Icons.share_rounded,
          color: context.colors.secondary,
          title: context.l10n.teacherShareReferral,
          subtitle: context.l10n.teacherShareReferralSub,
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: context.l10n.teacherReferralShareText),
            );
            AppSnackbar.show(context, context.l10n.teacherReferralLinkCopied);
          },
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppFrostedCard(
      onTap: onTap,
      padding: EdgeInsets.all(context.dimens.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            ),
            child: Icon(icon, color: color, size: context.dimens.iconMd),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colors.textSecondary,
            size: context.dimens.iconMd,
          ),
        ],
      ),
    );
  }
}
