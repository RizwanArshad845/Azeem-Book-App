import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../utils/name_initials.dart';

/// Shared branded greeting hero card (brandGradient fill, white text/avatar
/// chip) matching the app's onboarding "floating card" brand identity.
/// Used by both the Student Home and Teacher Overview dashboards so the two
/// greetings stay visually identical.
class GreetingHeroCard extends StatelessWidget {
  const GreetingHeroCard({
    super.key,
    required this.name,
    required this.greeting,
    this.subtitle,
  });

  /// Full name, used only to derive the avatar initials.
  final String name;

  /// Fully localized greeting line, e.g. "Hi, John! 👋".
  final String greeting;

  /// Optional line shown under the greeting.
  final String? subtitle;

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
              nameInitials(name),
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
                  greeting,
                  style: context.textStyles.titleLarge?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: context.dimens.xs / 2),
                  Text(
                    subtitle!,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
