import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/name_initials.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';

/// Compact personalized greeting with initials avatar and bold black title.
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.dimens.avatarSm,
          height: context.dimens.avatarSm,
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
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: context.dimens.sm),
        Expanded(
          child: Text(
            context.l10n.teacherOverviewWelcomeName(teacher.name),
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
