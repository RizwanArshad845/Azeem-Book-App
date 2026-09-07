import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth/entities/user_role.dart';
import '../../presentation/notifications/viewmodel/notifications_viewmodel.dart';
import '../constants/app_routes.dart';
import '../extensions/context_extensions.dart';

import 'app_language_toggle_button.dart';

/// The dedicated app-bar actions: Language toggle ('EN | اردو'),
/// Notifications bell with badge, and Profile icon.
class AppBarActions extends ConsumerWidget {
  const AppBarActions({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTeacher = role == UserRole.teacher;
    final notifications = ref.watch(notificationsViewModelProvider).value ?? [];
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLanguageToggleButton(),
        IconButton(
          icon: Badge.count(
            count: unreadCount,
            isLabelVisible: unreadCount > 0,
            child: Icon(
              unreadCount > 0
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_outlined,
              color: unreadCount > 0 ? context.colors.primary : null,
            ),
          ),
          tooltip: context.l10n.navNotifications,
          onPressed: () => context.push(
            isTeacher
                ? AppRoutes.teacherNotifications
                : AppRoutes.studentNotifications,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => context.push(
            isTeacher ? AppRoutes.teacherProfile : AppRoutes.studentProfile,
          ),
        ),
      ],
    );
  }
}
