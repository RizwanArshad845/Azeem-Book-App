import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth/entities/user_role.dart';
import '../constants/app_routes.dart';
import '../extensions/context_extensions.dart';

/// The two dedicated app-bar action icons that replace the old overflow
/// ("kebab") action menu (Round-2 spec): a Notifications bell and a Profile
/// icon. Profile opens the role's profile screen (which now hosts Language +
/// Logout); Notifications pushes the full-screen notifications list.
class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final isTeacher = role == UserRole.teacher;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
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
