import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';

/// Top horizontal header bar for the Teacher Dashboard featuring personalized greeting,
/// language toggle, and notification bell with unread counter.
class TeacherTopBar extends ConsumerWidget {
  const TeacherTopBar({super.key, required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(teacherUnreadNotificationsCountProvider);
    final currentLocale = ref.watch(localeProvider);
    final isUrdu = currentLocale?.languageCode == 'ur';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Teacher Avatar + Personalized Greeting
        CircleAvatar(
          radius: 22,
          backgroundColor: context.colors.primary.withValues(alpha: 0.15),
          child: Text(
            teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : 'T',
            style: context.textStyles.titleMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: context.dimens.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.teacherWelcomeBack(teacher.name),
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Right Utility Actions: Language Toggle + Notification Bell
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Language Toggle Pill
            InkWell(
              borderRadius: BorderRadius.circular(context.dimens.radiusLg),
              onTap: () {
                ref.read(localeProvider.notifier).toggleLocale();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.sm,
                  vertical: context.dimens.xs / 1.5,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(context.dimens.radiusLg),
                  border: Border.all(
                    color: context.colors.divider.withValues(alpha: 0.8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: context.dimens.iconSm,
                      color: context.colors.primary,
                    ),
                    SizedBox(width: context.dimens.xs / 2),
                    Text(
                      isUrdu ? 'اردو' : 'EN',
                      style: context.textStyles.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: context.dimens.xs),

            // Notification Bell with Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    context.push(AppRoutes.teacherNotifications);
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.colors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
