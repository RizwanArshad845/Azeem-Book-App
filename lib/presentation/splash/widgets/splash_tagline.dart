import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Animated tagline widget with slide-up and fade transitions for splash screen.
class SplashTagline extends StatelessWidget {
  const SplashTagline({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    this.text,
  });

  final Animation<double> fadeAnimation;
  final Animation<double> slideAnimation;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final taglineText = text ?? context.l10n.splashTagline;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: slideAnimation,
        builder: (context, child) {
          final offsetY = (dimens.md - 4) * (1.0 - slideAnimation.value);
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        child: Text(
          taglineText,
          style: context.textStyles.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
            letterSpacing: dimens.xs,
            fontSize: dimens.fontSm - 1,
          ),
        ),
      ),
    );
  }
}
