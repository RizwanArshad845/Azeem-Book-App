import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/name_initials.dart';
import '../../../domain/student_onboarding/entities/student.dart';

/// Student Home tab's signature greeting — mirrors
/// `teacher_overview/widgets/welcome_header.dart`'s gradient-initials-avatar
/// pattern so both role shells feel like the same app, using the
/// already-loaded [student]'s `name` (no new data dependency).
class StudentWelcomeHeader extends StatelessWidget {
  const StudentWelcomeHeader({super.key, required this.student});

  final Student student;

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
            nameInitials(student.name),
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
                context.l10n.studentHomeWelcomeName(student.name),
                style: context.textStyles.headlineSmall,
              ),
              SizedBox(height: context.dimens.xs / 2),
              Text(
                context.l10n.studentHomeWelcomeSubtitle,
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
