import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../extensions/context_extensions.dart';

/// Decorative background for onboarding screens: a soft brand gradient with
/// the Azeem logo watermarked large, blurred, and low-opacity in a corner —
/// reinforces the brand without competing with form content in the foreground.
class BlurredLogoBackdrop extends StatelessWidget {
  const BlurredLogoBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.background, colors.surfaceVariant],
            ),
          ),
        ),
        Positioned(
          top: -40,
          right: -40,
          child: Opacity(
            opacity: 0.13,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Image.asset(
                AppAssets.logo,
                width: context.dimens.logoWatermarkSize,
                height: context.dimens.logoWatermarkSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
