import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Determinate circular progress ring with a centered percentage label, used
/// by [GradingInProgressView] instead of a plain indeterminate spinner.
///
/// [progress] arrives from `TestTakingViewModel._pollUntilGraded` once per
/// ~2s poll tick — wrapping in [TweenAnimationBuilder] animates smoothly
/// toward each new value over that window instead of visibly jumping once
/// per tick.
class GradingProgressRing extends StatelessWidget {
  const GradingProgressRing({super.key, required this.progress, this.size = 96});

  /// 0.0-1.0. Values are expected to only ever increase (see the eased
  /// curve in `_pollUntilGraded`), so the tween always animates forward.
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 1800),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  backgroundColor: context.colors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.colors.primary,
                  ),
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
