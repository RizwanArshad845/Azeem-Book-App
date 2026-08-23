import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/name_initials.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';

/// Teacher Overview tab's signature greeting (CLAUDE.md: "Teacher Earnings:
/// ... personalized greeting (e.g., 'Welcome back, [Teacher Name]!')"). A
/// gradient initials avatar + one warm combined line replaces the old
/// generic two-line "Welcome back," / name split, using the already-loaded
/// [teacher]'s `name` — no new data dependency.
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.dimens.avatarLg,
          height: context.dimens.avatarLg,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [context.colors.primary, context.colors.secondary],
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            nameInitials(teacher.name),
            style: context.textStyles.titleLarge?.copyWith(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: context.dimens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.teacherOverviewWelcomeName(teacher.name),
                style: context.textStyles.headlineSmall,
              ),
              SizedBox(height: context.dimens.xs / 2),
              Text(
                context.l10n.teacherOverviewWelcomeSubtitle,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
