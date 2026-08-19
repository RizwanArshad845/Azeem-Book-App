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
                    ? context.colors.onPrimary
                    : context.colors.primary,
              ),
            ),
          )
        : icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: context.dimens.iconMd),
              SizedBox(width: context.dimens.sm),
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.outlined => OutlinedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.text => TextButton(onPressed: effectiveOnPressed, child: child),
    };

    return PressScale(enabled: !isDisabled, child: button);
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
