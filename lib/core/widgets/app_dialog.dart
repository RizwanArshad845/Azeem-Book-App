import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'dialog_actions.dart';
import 'dialog_header.dart';

/// Reusable modal dialog component adhering to the design system tokens.
/// Utilizes dimension tokens and context color extensions throughout.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.actions,
    this.showCloseButton = false,
    this.padding,
    this.maxWidth,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final List<Widget>? actions;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;

  /// Utility method to present an [AppDialog] modally.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    Widget? icon,
    List<Widget>? actions,
    bool showCloseButton = false,
    bool barrierDismissible = true,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AppDialog(
        title: title,
        subtitle: subtitle,
        icon: icon,
        actions: actions,
        showCloseButton: showCloseButton,
        padding: padding,
        maxWidth: maxWidth,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.dimens.dialogMaxWidth;

    return Dialog(
      backgroundColor: context.colors.surface,
      elevation: context.dimens.xs,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimens.radiusXl),
      ),
      insetPadding: EdgeInsets.all(context.dimens.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showCloseButton)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.dimens.xs,
                      right: context.dimens.xs,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: context.colors.textSecondary,
                        size: context.dimens.iconMd,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    ),
                  ),
                ),
              Padding(
                padding: padding ?? EdgeInsets.all(context.dimens.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (icon != null || title != null || subtitle != null)
                      DialogHeader(
                        icon: icon,
                        title: title,
                        subtitle: subtitle,
                      ),
                    child,
                  ],
                ),
              ),
              if (actions != null && actions!.isNotEmpty)
                DialogActions(actions: actions!),
            ],
          ),
        ),
      ),
    );
  }
}
