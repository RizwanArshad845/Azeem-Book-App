import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/name_initials.dart';
import '../../../domain/student_onboarding/entities/student.dart';

/// Student Home tab's signature greeting — a full branded hero card
/// (brandGradient fill, white text/avatar chip) matching the app's
/// onboarding "floating card" brand identity, rather than bare text sitting
/// directly on the page background.
class StudentWelcomeHeader extends StatelessWidget {
  const StudentWelcomeHeader({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dimens.lg),
      decoration: BoxDecoration(
        gradient: context.colors.brandGradient,
        borderRadius: BorderRadius.circular(context.dimens.radiusLg),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: context.dimens.avatarLg,
            height: context.dimens.avatarLg,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
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
                  style: context.textStyles.titleLarge?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  context.l10n.studentHomeWelcomeSubtitle,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
