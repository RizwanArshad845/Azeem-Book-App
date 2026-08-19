import 'dart:ui';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_scaffold_with_bottom_nav.dart';

/// Modern floating glassmorphic bottom navigation bar inspired by premium UI patterns.
/// Features backdrop blur, pill elevation, animated selection state, and micro-scale feedback.
class FloatingGlassNavBar extends StatelessWidget {
  const FloatingGlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final List<BottomNavDestinationSpec> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.dimens.md,
        0,
        context.dimens.md,
        bottomInset > 0 ? bottomInset + context.dimens.xs : context.dimens.md,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.dimens.radiusXl * 1.5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: context.dimens.xl * 2.6,
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(context.dimens.radiusXl * 1.5),
              border: Border.all(
                color: context.colors.divider.withValues(alpha: 0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: context.dimens.lg,
                  offset: Offset(0, context.dimens.xs),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < destinations.length; i++)
                  Expanded(
                    child: _NavBarItemTile(
                      spec: destinations[i],
                      isSelected: i == selectedIndex,
                      onTap: () => onDestinationSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItemTile extends StatelessWidget {
  const _NavBarItemTile({
    required this.spec,
    required this.isSelected,
    required this.onTap,
  });

  final BottomNavDestinationSpec spec;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.colors.primary;
    final inactiveColor = context.colors.textSecondary;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? context.dimens.md : context.dimens.xs,
            vertical: context.dimens.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(context.dimens.pillRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                spec.icon,
                color: isSelected ? activeColor : inactiveColor,
                size: context.dimens.iconMd,
              ),
              SizedBox(height: context.dimens.xs / 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: context.textStyles.labelSmall!.copyWith(
                  color: isSelected ? activeColor : inactiveColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                child: Text(
                  spec.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
