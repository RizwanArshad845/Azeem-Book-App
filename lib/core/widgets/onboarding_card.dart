import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable floating white card container holding onboarding form content.
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

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.dimens.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.09),
                blurRadius: context.dimens.xl,
                offset: Offset(0, context.dimens.xs),
              ),
            ],
          ),
          padding: padding ?? EdgeInsets.all(context.dimens.lg),
          child: child,
        ),
      ),
    );
  }
}
