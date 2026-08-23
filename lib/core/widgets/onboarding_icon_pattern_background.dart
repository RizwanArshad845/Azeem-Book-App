import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Which onboarding flow is currently rendering, so the generated icon
/// pattern can use a distinct icon vocabulary per role instead of student
/// and teacher onboarding feeling like palette swaps of each other.
enum OnboardingRole { student, teacher }

/// Generated background pattern of tiled, low-opacity, rotated native
/// Flutter icons — replaces the old flat static `study_bg.png` per
/// CLAUDE.md's "branded background pattern populated with generated
/// icons/emojis" spec. Deterministic (no `Random`) so it renders
/// identically every build/rebuild.
class OnboardingIconPatternBackground extends StatelessWidget {
  const OnboardingIconPatternBackground({super.key, required this.role});

  final OnboardingRole role;

  static const _studentIcons = [
    Icons.menu_book,
    Icons.edit,
    Icons.school,
    Icons.calculate,
  ];

  static const _teacherIcons = [
    Icons.cast_for_education,
    Icons.groups,
    Icons.workspace_premium,
    Icons.fact_check,
  ];

  @override
  Widget build(BuildContext context) {
    final icons = role == OnboardingRole.student ? _studentIcons : _teacherIcons;
    final tint = context.colors.primary;

    return IgnorePointer(
      child: ColoredBox(
        color: context.colors.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 5;
            final cellSize = constraints.maxWidth / crossAxisCount;
            final rowCount = (constraints.maxHeight / cellSize).ceil() + 1;
            final itemCount = crossAxisCount * rowCount;

            return GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final icon = icons[index % icons.length];
                // Deterministic pseudo-random rotation/opacity per cell so
                // the pattern doesn't read as a repeating grid.
                final angle = ((index * 47) % 360) * math.pi / 180;
                final opacity = 0.04 + ((index * 7) % 5) * 0.01;
                return Center(
                  child: Transform.rotate(
                    angle: angle,
                    child: Icon(
                      icon,
                      size: cellSize * 0.42,
                      color: tint.withValues(alpha: opacity),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
