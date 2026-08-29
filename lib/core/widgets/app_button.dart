import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'press_scale.dart';

enum AppButtonVariant { primary, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    final child = loading
        ? SizedBox(
            height: context.dimens.iconMd,
            width: context.dimens.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? context.colors.onAccent
                    : context.colors.primary,
              ),
            ),
          )
        : icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: context.dimens.iconMd),
              SizedBox(width: context.dimens.sm),
              Text(label),
            ],
          );

    if (variant == AppButtonVariant.primary) {
      final primaryColor = context.colors.primary;
      final gradientEnd = Color.lerp(primaryColor, const Color(0xFF1E6B52), 0.4) ?? primaryColor;

      return PressScale(
        enabled: !isDisabled,
        haptic: true,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.55 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(context.dimens.pillRadius),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.32),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: effectiveOnPressed,
                borderRadius: BorderRadius.circular(context.dimens.pillRadius),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.lg,
                    vertical: context.dimens.md - 2,
                  ),
                  child: Center(
                    child: DefaultTextStyle.merge(
                      style: context.textStyles.labelLarge?.copyWith(
                        color: context.colors.onAccent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                      child: IconTheme.merge(
                        data: IconThemeData(color: context.colors.onAccent),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final button = switch (variant) {
      AppButtonVariant.primary => const SizedBox.shrink(),
      AppButtonVariant.outlined => OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimens.pillRadius),
            ),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.text => TextButton(onPressed: effectiveOnPressed, child: child),
    };

    return PressScale(enabled: !isDisabled, haptic: true, child: button);
  }
}

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      loading: loading,
      icon: icon,
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.outlined,
      loading: loading,
      icon: icon,
    );
  }
}

class AppDangerButton extends StatelessWidget {
  const AppDangerButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    final child = loading
        ? SizedBox(
            height: context.dimens.iconMd,
            width: context.dimens.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.error),
            ),
          )
        : icon == null
            ? Text(label, style: TextStyle(color: context.colors.error))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: context.dimens.iconMd, color: context.colors.error),
                  SizedBox(width: context.dimens.sm),
                  Text(label, style: TextStyle(color: context.colors.error)),
                ],
              );

    return PressScale(
      enabled: !isDisabled,
      haptic: true,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.error,
          side: BorderSide(color: context.colors.error),
        ),
        onPressed: effectiveOnPressed,
        child: child,
      ),
    );
  }
}
