import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_logo.dart';

/// Animated splash logo with entrance scaling, fade-in, and glowing shadow aura.
class SplashAnimatedLogo extends StatelessWidget {
  const SplashAnimatedLogo({
    super.key,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.glowAnimation,
  });

  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final Animation<double> glowAnimation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return RepaintBoundary(
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: AnimatedBuilder(
            animation: glowAnimation,
            builder: (context, child) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.secondary.withValues(
                        alpha: 0.25 + 0.15 * glowAnimation.value,
                      ),
                      blurRadius: dimens.xl + (dimens.md * glowAnimation.value),
                      spreadRadius: dimens.xs / 2 + (dimens.xs * glowAnimation.value),
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: AppLogo(size: dimens.avatarLg * 2),
          ),
        ),
      ),
    );
  }
}
