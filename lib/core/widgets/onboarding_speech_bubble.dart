import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Small decorative "speech bubble" accent for onboarding screens — a short
/// friendly line in a rounded pill, per CLAUDE.md's "Kiraya card" spec
/// (floating card layout with dialogue bubbles around it).
class OnboardingSpeechBubble extends StatelessWidget {
  const OnboardingSpeechBubble({
    super.key,
    required this.message,
    this.icon,
    this.alignment = Alignment.centerLeft,
  });

  final String message;
  final IconData? icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimens.md,
          vertical: context.dimens.sm,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(context.dimens.pillRadius),
          border: Border.all(
            color: context.colors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: context.dimens.sm,
              offset: Offset(0, context.dimens.xs / 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: context.dimens.iconSm, color: context.colors.secondary),
              SizedBox(width: context.dimens.xs),
            ],
            Flexible(
              child: Text(
                message,
                style: context.textStyles.labelSmall?.copyWith(
                  color: context.colors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
