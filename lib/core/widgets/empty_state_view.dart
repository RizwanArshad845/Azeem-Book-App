import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_button.dart';

/// Shared "nothing here yet" state per §10.1 — one optional primary action,
/// no per-screen custom variants.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.dimens.iconLg * 1.5,
              color: context.colors.textSecondary,
            ),
            SizedBox(height: context.dimens.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: context.dimens.lg),
              AppButton(
                label: actionLabel!,
                variant: AppButtonVariant.outlined,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
