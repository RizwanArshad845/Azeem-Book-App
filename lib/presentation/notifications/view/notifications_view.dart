import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../viewmodel/notifications_viewmodel.dart';

/// Redesigned Notifications tab with color-coded notification badges,
/// bulk "Mark all as read" and "Clear all" actions, and frosted glass cards.
class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsViewModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: AppBarTitle(context.l10n.notificationsTitle),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // "Mark all as read" action
          IconButton(
            tooltip: context.l10n.notificationsMarkAllRead,
            icon: const Icon(Icons.done_all_rounded),
            onPressed: () {
              ref
                  .read(notificationsViewModelProvider.notifier)
                  .markAllAsRead();
            },
          ),
          // "Clear all" action
          IconButton(
            tooltip: context.l10n.notificationsClearAll,
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () async {
              final confirmed = await confirmDialog(
                context,
                title: context.l10n.notificationsClearConfirmTitle,
                message: context.l10n.notificationsClearConfirmMessage,
                confirmLabel: context.l10n.notificationsClearAll,
                isDestructive: true,
              );
              if (confirmed == true) {
                ref.read(notificationsViewModelProvider.notifier).clearAll();
              }
            },
          ),
        ],
      ),
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh:
                () async => ref.invalidate(notificationsViewModelProvider),
            child: AsyncValueWidget<List<Notification>>(
              value: notificationsAsync,
              onRetry: () => ref.invalidate(notificationsViewModelProvider),
              skeleton: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.lg,
                  vertical: context.dimens.md,
                ),
                child: const SkeletonList(itemCount: 6, itemHeight: 70),
              ),
              data: (notifications) {
                if (notifications.isEmpty) {
                  return LayoutBuilder(
                    builder:
                        (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: EmptyStateView(
                              message: context.l10n.notificationsEmpty,
                              icon: Icons.notifications_none_outlined,
                            ),
                          ),
                        ),
                  );
                }
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.lg,
                    vertical: context.dimens.md,
                  ),
                  itemCount: notifications.length,
                  separatorBuilder:
                      (_, _) => SizedBox(height: context.dimens.sm),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationCard(notification: notification);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification});

  final Notification notification;

  (IconData, Color) get _style => switch (notification.type) {
    NotificationType.studentRegistered => (
      Icons.person_add_rounded,
      const Color(0xFF2563EB), // Royal Blue
    ),
    NotificationType.discountAnnouncement => (
      Icons.local_offer_rounded,
      const Color(0xFF059669), // Emerald Green
    ),
    NotificationType.newTestUploaded => (
      Icons.assignment_rounded,
      const Color(0xFF7C3AED), // Purple
    ),
    NotificationType.liveTestReminder => (
      Icons.podcasts_rounded,
      const Color(0xFFD97706), // Amber
    ),
    NotificationType.profileUpdatePending => (
      Icons.pending_actions_rounded,
      const Color(0xFFEA580C), // Orange
    ),
    NotificationType.teacherAwaitingApproval => (
      Icons.hourglass_top_rounded,
      const Color(0xFFD97706), // Amber
    ),
    NotificationType.paymentSuccessful || NotificationType.studentEnrolled => (
      Icons.check_circle_rounded,
      const Color(0xFF059669), // Emerald Green
    ),
    NotificationType.earningsCredited => (
      Icons.payments_rounded,
      const Color(0xFF059669), // Emerald Green
    ),
    NotificationType.resultReady || NotificationType.liveTestCompleted => (
      Icons.emoji_events_rounded,
      const Color(0xFF7C3AED), // Purple
    ),
    NotificationType.testGradingFailed => (
      Icons.error_outline_rounded,
      const Color(0xFFDC2626), // Red
    ),
    // Every other defined `NotificationType` (§8: not yet triggered by any
    // real backend event today, plus the `unknown` decode fallback) — a
    // generic bell so an unrecognized/future type still renders instead of
    // hitting a non-exhaustive-switch build error.
    _ => (Icons.notifications_rounded, const Color(0xFF64748B)), // Slate
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = !notification.isRead;
    final (icon, badgeColor) = _style;

    return AppFrostedCard(
      onTap:
          isUnread
              ? () => ref
                  .read(notificationsViewModelProvider.notifier)
                  .markAsRead(notification.id)
              : null,
      padding: EdgeInsets.all(context.dimens.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color-Coded Icon Badge
          Container(
            padding: EdgeInsets.all(context.dimens.sm),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: badgeColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: badgeColor, size: 20),
          ),
          SizedBox(width: context.dimens.md),

          // Message & Timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.displayMessage,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                    color:
                        isUnread
                            ? context.colors.textPrimary
                            : context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(
                    notification.createdAt,
                  ),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Unread Indicator Dot
          if (isUnread) ...[
            SizedBox(width: context.dimens.xs),
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(top: context.dimens.xs),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
