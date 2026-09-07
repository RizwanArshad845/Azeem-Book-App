import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../utils/name_initials.dart';
import 'app_frosted_card.dart';

/// Shared profile header: gradient initials avatar, name, phone, and a
/// verified badge pill — used by both the teacher and student profile
/// screens so the two stay visually in sync.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.badgeLabel,
  });

  final String name;
  final String phoneNumber;
  final String badgeLabel;

  @override
  Widget build(BuildContext context) {
    return AppFrostedCard(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
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
              nameInitials(name),
              style: context.textStyles.headlineSmall?.copyWith(
                color: context.colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: context.dimens.sm),
          Text(
            name,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.dimens.xs / 3),
          Text(
            phoneNumber,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimens.sm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.md,
              vertical: context.dimens.xs / 2,
            ),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusLg),
              border: Border.all(
                color: context.colors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: context.colors.success,
                  size: context.dimens.iconSm,
                ),
                SizedBox(width: context.dimens.xs),
                Text(
                  badgeLabel,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: context.colors.success,
                    fontWeight: FontWeight.bold,
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
