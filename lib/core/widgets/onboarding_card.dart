import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable floating glassmorphic card container holding onboarding form
/// content — semi-transparent surface + backdrop blur + a subtle 1px light
/// border, so the generated icon-pattern background shows through softly
/// instead of a flat opaque card (CLAUDE.md's "Kiraya card" spec).
class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.dimens.contentMaxWidth;
    final radius = BorderRadius.circular(28.0);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
      child: Container(
        width: double.infinity,
        // Shadow lives on the un-clipped outer container so it isn't
        // cut off by the inner blur's ClipRRect.
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surface.withValues(alpha: 0.88),
                borderRadius: radius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45),
                  width: 1.5,
                ),
              ),
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: context.dimens.xl,
                    vertical: context.dimens.xl,
                  ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
