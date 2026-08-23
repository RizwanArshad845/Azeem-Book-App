import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Ambient subtle background radial glow behind the splash logo.
class SplashAmbientGlow extends StatelessWidget {
  const SplashAmbientGlow({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Positioned.fill(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value * 0.45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.15),
                    radius: 0.75,
                    colors: [
                      colors.secondary.withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
