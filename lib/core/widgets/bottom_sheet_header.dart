import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable header row for modal bottom sheets with title, subtitle, close button, and divider.
class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
    this.title,
    this.subtitle,
    this.showCloseButton = true,
    this.onClose,
  });

  final String? title;
  final String? subtitle;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.dimens.lg,
            context.dimens.md,
            context.dimens.sm,
            context.dimens.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: context.textStyles.titleLarge?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (subtitle != null) ...[
                      SizedBox(height: context.dimens.xs),
                      Text(
                        subtitle!,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showCloseButton)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: context.colors.textSecondary,
                    size: context.dimens.iconMd,
                  ),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                ),
            ],
          ),
        ),
        Divider(height: 1, color: context.colors.divider),
      ],
    );
  }
}
