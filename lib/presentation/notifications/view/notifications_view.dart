// The domain `Notification` entity collides with Flutter's own
// `Notification` widget-tree class (e.g. `ScrollNotification`), so it's
// hidden here — this view only ever needs the domain type.
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/notifications/entities/notification.dart';
import '../viewmodel/notifications_viewmodel.dart';

/// Shared Notifications tab root for both the Student and Teacher shells
/// (§10.2: Student — "Live-test reminders, new test uploads, discount
/// announcements"; Teacher — "'Student Y registered at time X', new
/// signups"). One view serves both roles since the viewmodel already
/// filters by the logged-in user's `recipientId` (`currentUserProvider`).
/// Read-only list, no primary action button (§10.1's "one primary action"
/// rule doesn't force a button where the tab's whole purpose is browsing —
/// tapping a card is the only interaction, marking it read).
class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notificationsTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(notificationsViewModelProvider),
          child: AsyncValueWidget<List<Notification>>(
            value: notificationsAsync,
            onRetry: () => ref.invalidate(notificationsViewModelProvider),
            data: (notifications) {
              if (notifications.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: const EmptyStateView(
                        message: 'No notifications yet',
                        icon: Icons.notifications_none_outlined,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(context.dimens.lg),
                itemCount: notifications.length,
                separatorBuilder: (_, _) => SizedBox(height: context.dimens.md),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _NotificationCard(notification: notification);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification});

  final Notification notification;

  IconData get _icon => switch (notification.type) {
    NotificationType.studentRegistered => Icons.person_add_alt_outlined,
    NotificationType.profileUpdatePending => Icons.pending_actions_outlined,
    NotificationType.teacherAwaitingApproval =>
      Icons.hourglass_top_outlined,
    NotificationType.newTestUploaded => Icons.assignment_outlined,
    NotificationType.discountAnnouncement => Icons.local_offer_outlined,
    NotificationType.liveTestReminder => Icons.podcasts_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = !notification.isRead;

    return AppListRow(
      onTap: isUnread
          ? () => ref
                .read(notificationsViewModelProvider.notifier)
                .markAsRead(notification.id)
          : null,
      leading: Icon(
        _icon,
        color: isUnread ? context.colors.primary : context.colors.textSecondary,
      ),
      title: notification.message,
      titleStyle: isUnread
          ? context.textStyles.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
          : context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
      subtitle: Text(
        DateFormat('MMM d, h:mm a').format(notification.createdAt),
        style: context.textStyles.bodySmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
      trailing: isUnread
          ? Container(
              width: context.dimens.sm,
              height: context.dimens.sm,
              margin: EdgeInsets.only(top: context.dimens.xs / 2),
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
