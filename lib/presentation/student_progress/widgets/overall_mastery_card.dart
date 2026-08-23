import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';

/// Signature "hero" element for the Progress screen (CLAUDE.md: "Progress
/// Screen: Visually attractive & detailed analytics") — a dynamic circular
/// mastery ring with a gradient stroke, replacing what used to be a bare
/// percentage number. Built as a `Stack` of two `CircularProgressIndicator`s
/// (a flat track + a `ShaderMask`-tinted gradient arc) rather than a custom
/// `CustomPainter`, since it's the simpler of the two approaches the plan
/// allows for and needs no extra painting/hit-testing logic.
class OverallMasteryCard extends StatelessWidget {
  const OverallMasteryCard({
    super.key,
    required this.masteryPercent,
    required this.testsAttempted,
  });

  /// Average `TestAttempt.scorePercent` across every attempt (0-100).
  final double masteryPercent;
  final int testsAttempted;

  @override
  Widget build(BuildContext context) {
    final clamped = masteryPercent.clamp(0, 100).toDouble();

    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 9,
                  color: context.colors.surfaceVariant,
                ),
                ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.secondary, context.colors.primary],
                  ).createShader(rect),
                  child: CircularProgressIndicator(
                    value: clamped / 100,
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                Text(
                  '${clamped.toStringAsFixed(0)}%',
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.dimens.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.progressMasteryTitle,
                  style: context.textStyles.titleMedium,
                ),
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  context.l10n.progressMasteryTestsCount(testsAttempted),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
