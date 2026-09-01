import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth/entities/user_role.dart';
import '../constants/app_routes.dart';
import '../extensions/context_extensions.dart';

import 'app_language_toggle_button.dart';

/// The dedicated app-bar actions: Language toggle ('EN | اردو'),
/// Notifications bell with badge, and Profile icon.
class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final isTeacher = role == UserRole.teacher;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLanguageToggleButton(),
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
