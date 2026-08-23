import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Lightweight letter-by-letter handwriting/typewriter title animation for splash.
class SplashWrittenTitle extends StatelessWidget {
  const SplashWrittenTitle({
    super.key,
    required this.progress,
    this.text,
    this.accentColor,
  });

  final Animation<double> progress;
  final String? text;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final titleText = text ?? context.l10n.splashBrandName;
    final characters = titleText.characters.toList();
    final dimens = context.dimens;
    final effectiveAccentColor = accentColor ?? context.colors.secondary;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, child) {
          final t = progress.value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < characters.length; i++)
                _buildLetter(
                  context,
                  characters[i],
                  i,
                  characters.length,
                  t,
                  effectiveAccentColor,
                ),
              // Dynamic typing cursor that leads the writing and dissolves at the end
              if (t > 0.05 && t < 0.98)
                Opacity(
                  opacity: (1.0 - t).clamp(0.4, 1.0),
                  child: Container(
                    margin: EdgeInsets.only(left: dimens.xs - 1),
                    width: dimens.xs - 1,
                    height: dimens.lg + dimens.xs,
                    decoration: BoxDecoration(
                      color: effectiveAccentColor,
                      borderRadius: BorderRadius.circular(dimens.radiusSm),
                      boxShadow: [
                        BoxShadow(
                          color: effectiveAccentColor.withValues(alpha: 0.7),
                          blurRadius: dimens.sm - 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLetter(
    BuildContext context,
    String character,
    int index,
    int totalCount,
    double globalProgress,
    Color accentColor,
  ) {
    final dimens = context.dimens;
    final step = 1.0 / (totalCount == 0 ? 1 : totalCount);
    final letterStart = index * step * 0.85;
    final letterEnd = (letterStart + step * 0.95).clamp(0.0, 1.0);

    final localT = ((globalProgress - letterStart) / (letterEnd - letterStart))
        .clamp(0.0, 1.0);

    if (localT <= 0.0) {
      return const SizedBox(width: 0, height: 0);
    }

    final bounce = Curves.easeOutBack.transform(localT);
    final offsetY = (dimens.md - 6) * (1.0 - bounce);
    final scale = 0.7 + 0.3 * bounce;

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: localT,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimens.xs / 2 + 0.5),
            child: Text(
              character,
              style: context.textStyles.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: dimens.xl,
                letterSpacing: dimens.xs / 2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    offset: const Offset(0, 3),
                    blurRadius: dimens.sm,
                  ),
                  Shadow(
                    color: accentColor.withValues(alpha: 0.35 * localT),
                    offset: Offset.zero,
                    blurRadius: dimens.md - 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
