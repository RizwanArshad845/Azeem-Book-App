import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable Frosted Glassmorphic card matching the exact onboarding design system:
/// 76% translucent surface, 18px backdrop gaussian blur, soft glass border, and subtle depth shadow.
class AppFrostedCard extends StatelessWidget {
  const AppFrostedCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(context.dimens.radiusLg);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg =
        isDark
            ? Colors.black.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.76);

    final defaultBorder = Border.all(
      color:
          isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.85),
      width: 1.2,
    );

    Widget content = Container(
      padding: padding ?? EdgeInsets.all(context.dimens.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: effectiveRadius,
        border: border ?? defaultBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: effectiveRadius,
          onTap: onTap,
          child: content,
        ),
      );
    }

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: content,
      ),
    );
  }
}
