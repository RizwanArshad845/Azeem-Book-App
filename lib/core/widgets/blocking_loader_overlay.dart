import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// Full-screen, non-dismissible loader for app-wide actions the user must
/// wait out (signing in, logging out): dims the app, swallows every tap so
/// nothing can be pressed twice or mid-way, and says what's happening.
class BlockingLoaderOverlay extends StatelessWidget {
  const BlockingLoaderOverlay({
    super.key,
    required this.message,
    this.hint,
  });

  final String message;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: context.colors.textPrimary.withValues(alpha: 0.45),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(context.dimens.xl),
              child: Semantics(
                liveRegion: true,
                label: message,
                child: AppCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.xl,
                    vertical: context.dimens.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: context.colors.primary),
                      SizedBox(height: context.dimens.md),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: context.textStyles.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hint != null) ...[
                        SizedBox(height: context.dimens.xs),
                        Text(
                          hint!,
                          textAlign: TextAlign.center,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
