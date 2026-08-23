import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'press_scale.dart';

enum AppButtonVariant { primary, outlined, text }

enum AppButtonIconPosition { leading, trailing }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.iconPosition = AppButtonIconPosition.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    final labelWidget = Flexible(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final iconWidget =
        icon != null ? Icon(icon, size: context.dimens.iconMd) : null;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconPosition == AppButtonIconPosition.trailing
                    ? [
                        labelWidget,
                        SizedBox(width: context.dimens.sm),
                        iconWidget!,
                      ]
                    : [
                        iconWidget!,
                        SizedBox(width: context.dimens.sm),
                        labelWidget,
                      ],
              );

    final button = switch (variant) {
      AppButtonVariant.primary =>
        ElevatedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.outlined =>
        OutlinedButton(onPressed: effectiveOnPressed, child: child),
      AppButtonVariant.text =>
        TextButton(onPressed: effectiveOnPressed, child: child),
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
    this.iconPosition = AppButtonIconPosition.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      loading: loading,
      icon: icon,
      iconPosition: iconPosition,
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
    this.iconPosition = AppButtonIconPosition.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.outlined,
      loading: loading,
      icon: icon,
      iconPosition: iconPosition,
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
    this.iconPosition = AppButtonIconPosition.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    final labelWidget = Flexible(
      child: Text(
        label,
        style: TextStyle(color: context.colors.error),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final iconWidget = icon != null
        ? Icon(icon, size: context.dimens.iconMd, color: context.colors.error)
        : null;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconPosition == AppButtonIconPosition.trailing
                    ? [
                        labelWidget,
                        SizedBox(width: context.dimens.sm),
                        iconWidget!,
                      ]
                    : [
                        iconWidget!,
                        SizedBox(width: context.dimens.sm),
                        labelWidget,
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
