import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable header layout for modal dialogs with icon, title, and subtitle.
class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
  });

  final Widget? icon;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (icon != null) ...[
          Center(child: icon),
          SizedBox(height: context.dimens.md),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: context.textStyles.titleLarge?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.dimens.xs),
        ],
        if (subtitle != null) ...[
          Text(
            subtitle!,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.dimens.md),
        ],
      ],
    );
  }
}
