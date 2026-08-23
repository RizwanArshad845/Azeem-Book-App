import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../domain/notifications/entities/notification.dart' as entity;
import '../../notifications/viewmodel/notifications_viewmodel.dart';

/// Displays the latest real-time student signups and bundle purchases on the Overview tab.
class TeacherRecentActivitySection extends ConsumerWidget {
  const TeacherRecentActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.teacherRecentActivity,
              style: context.textStyles.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.teacherNotifications),
              child: Text(context.l10n.commonViewAll),
            ),
          ],
        ),
        SizedBox(height: context.dimens.xs),
        AsyncValueWidget<List<entity.Notification>>(
          value: notifsAsync,
          onRetry: () => ref.invalidate(notificationsViewModelProvider),
          data: (notifications) {
            if (notifications.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.dimens.md),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                  border: Border.all(
                    color: context.colors.divider.withValues(alpha: 0.6),
                  ),
                ),
                child: Center(
                  child: Text(
                    'No recent activity yet.',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              );
            }

            final recentList = notifications.take(3).toList();

            return AppFrostedCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (int i = 0; i < recentList.length; i++) ...[
                    _ActivityRow(notification: recentList[i]),
                    if (i < recentList.length - 1)
                      Divider(
                        color: context.colors.divider.withValues(alpha: 0.5),
                        height: 1,
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.notification});

  final entity.Notification notification;

  @override
  Widget build(BuildContext context) {
    final isCommission =
        notification.message.contains('commission') ||
        notification.message.contains('purchased');

    final icon =
        isCommission
            ? Icons.shopping_bag_outlined
            : Icons.person_add_alt_1_outlined;
    final iconColor =
        isCommission ? const Color(0xFF059669) : context.colors.primary;
    final iconBg =
        isCommission
            ? const Color(0xFF059669).withValues(alpha: 0.12)
            : context.colors.primary.withValues(alpha: 0.12);

    return Padding(
      padding: EdgeInsets.all(context.dimens.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.xs * 1.5),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(context.dimens.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: context.dimens.xs / 3),
                Text(
                  _timeAgo(notification.createdAt),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
