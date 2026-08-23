import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Golden accent divider with entrance scaling animation for splash screen.
class SplashGoldenDivider extends StatelessWidget {
  const SplashGoldenDivider({
    super.key,
    required this.scaleAnimation,
  });

  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        width: dimens.xxl + dimens.sm,
        height: dimens.xs - 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.secondary.withValues(alpha: 0.2),
              colors.secondary,
              colors.secondary.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(dimens.radiusSm),
          boxShadow: [
            BoxShadow(
              color: colors.secondary.withValues(alpha: 0.4),
              blurRadius: dimens.sm,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
