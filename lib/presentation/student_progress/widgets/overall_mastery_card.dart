import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';

/// Signature "hero" element for the Progress screen (CLAUDE.md: "Progress
/// Screen: Visually attractive & detailed analytics") — a dynamic circular
/// mastery ring with a gradient stroke and rounded caps. Built with a custom
/// painter to guarantee zero clipping of stroke caps or borders.
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
    final progress = clamped / 100.0;

    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final ringSize = (constraints.maxWidth * 0.22).clamp(72.0, 96.0);
          final strokeWidth = 8.0;

          return Row(
            children: [
              SizedBox(
                width: ringSize,
                height: ringSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(ringSize, ringSize),
                      painter: _MasteryRingPainter(
                        progress: progress,
                        trackColor: context.colors.primary.withValues(alpha: 0.1),
                        progressGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colors.primary,
                            context.colors.secondary,
                          ],
                        ),
                        strokeWidth: strokeWidth,
                      ),
                    ),
                    Text(
                      '${clamped.toStringAsFixed(0)}%',
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.dimens.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.progressMasteryTitle,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
          );
        },
      ),
    );
  }
}

class _MasteryRingPainter extends CustomPainter {
  _MasteryRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressGradient,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Gradient progressGradient;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Outer background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final progressPaint = Paint()
        ..shader = progressGradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Start from 12 o'clock (-pi/2)
      final startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MasteryRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
