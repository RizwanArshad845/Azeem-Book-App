import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Design variants for experimenting with soft, eye-friendly card aesthetics.
enum OnboardingCardStyle {
  /// Option 1: Frosted glassmorphism with translucent background and backdrop blur
  frostedGlass,

  /// Option 2: Warm matte paper / slate off-white (noticeably soft on the eyes)
  matteOffWhite,

  /// Option 3: Original solid white surface
  classic,

  /// Option 4: Visible pearl-to-mist micro-gradient
  microGradient,
}

/// Reusable floating card container holding onboarding form content with distinct soft themes.
class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
    this.style = OnboardingCardStyle.frostedGlass,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final OnboardingCardStyle style;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.dimens.contentMaxWidth;
    final borderRadius = BorderRadius.circular(context.dimens.radiusXl);
    final cardPadding = padding ?? EdgeInsets.all(context.dimens.lg);

    Widget contentContainer;

    switch (style) {
      case OnboardingCardStyle.frostedGlass:
        // Option 1: Frosted Glassmorphism (Translucent with visible background blur)
        contentContainer = ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: cardPadding,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.76),
                borderRadius: borderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.90),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
        break;

      case OnboardingCardStyle.matteOffWhite:
        // Option 2: Warm Matte Paper / Slate (Soothing, distinct from stark white)
        contentContainer = Container(
          padding: cardPadding,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: borderRadius,
            border: Border.all(
              color: const Color(0xFFD1D5DB),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        );
        break;

      case OnboardingCardStyle.microGradient:
        // Option 4: Distinct Pearl-to-Mist Micro-Gradient
        contentContainer = Container(
          padding: cardPadding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFE2E8F0),
              ],
            ),
            borderRadius: borderRadius,
            border: Border.all(
              color: const Color(0xFFCBD5E1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 22,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        );
        break;

      case OnboardingCardStyle.classic:
        // Original solid white card
        contentContainer = Container(
          padding: cardPadding,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.09),
                blurRadius: context.dimens.xl,
                offset: Offset(0, context.dimens.xs),
              ),
            ],
          ),
          child: child,
        );
        break;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: contentContainer,
      ),
    );
  }
}
