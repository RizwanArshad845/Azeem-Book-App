import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Pulsating 3-dot loading indicator positioned at the bottom of the splash screen.
class SplashPulseDots extends StatelessWidget {
  const SplashPulseDots({
    super.key,
    required this.fadeAnimation,
    this.color,
  });

  final Animation<double> fadeAnimation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final dotColor = color ?? context.colors.secondary;

    return Positioned(
      left: 0,
      right: 0,
      bottom: dimens.xxl,
      child: RepaintBoundary(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: dimens.xs),
                width: dimens.sm - 2,
                height: dimens.sm - 2,
                decoration: BoxDecoration(
                  color: dotColor.withValues(alpha: 0.45 + (index * 0.2)),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
