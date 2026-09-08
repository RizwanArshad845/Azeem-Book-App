import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_button.dart';

/// Shared error state per §8 — uniform rendering for any repository/use
/// case [Failure] surfaced at the view layer.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.isOffline = false,
  });

  final String message;
  final VoidCallback? onRetry;

  /// True when this error stems from a [NetworkFailure] (no connectivity),
  /// so the icon can read as "you're offline" rather than a generic failure.
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.error_outline,
              size: context.dimens.iconLg * 1.5,
              color: context.colors.error,
            ),
            SizedBox(height: context.dimens.md),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              SizedBox(height: context.dimens.md),
              AppButton(
                label: 'Retry',
                variant: AppButtonVariant.outlined,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
