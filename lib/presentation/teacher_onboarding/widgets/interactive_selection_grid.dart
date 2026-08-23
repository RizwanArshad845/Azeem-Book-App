import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Reusable multi-select grid with modern interactive selectable chips/tiles.
/// Features icons, checkmark indicators, and animated highlight backgrounds.
class InteractiveSelectionGrid<T> extends StatelessWidget {
  const InteractiveSelectionGrid({
    super.key,
    required this.options,
    required this.optionId,
    required this.optionLabel,
    this.optionIcon,
    required this.selectedIds,
    required this.onChanged,
    this.emptyMessage,
  });

  final List<T> options;
  final String Function(T option) optionId;
  final String Function(T option) optionLabel;
  final IconData Function(T option)? optionIcon;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.dimens.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.dimens.radiusMd),
          border: Border.all(color: context.colors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: context.colors.textSecondary,
              size: context.dimens.iconLg,
            ),
            SizedBox(height: context.dimens.xs),
            Text(
              emptyMessage ?? 'No options available.',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: context.dimens.sm,
      runSpacing: context.dimens.sm,
      children: [
        for (final option in options)
          _SelectionTile(
            label: optionLabel(option),
            icon: optionIcon != null ? optionIcon!(option) : null,
            isSelected: selectedIds.contains(optionId(option)),
            onTap: () {
              final next = Set<String>.of(selectedIds);
              final id = optionId(option);
              if (next.contains(id)) {
                next.remove(id);
              } else {
                next.add(id);
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withValues(alpha: 0.12)
            : context.colors.surface,
        borderRadius: BorderRadius.circular(context.dimens.radiusMd),
        border: Border.all(
          color: isSelected ? primaryColor : context.colors.divider,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.dimens.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.md,
              vertical: context.dimens.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: context.dimens.iconSm * 1.1,
                    color: isSelected
                        ? primaryColor
                        : context.colors.textSecondary,
                  ),
                  SizedBox(width: context.dimens.xs),
                ],
                Text(
                  label,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? primaryColor
                        : context.colors.textPrimary,
                  ),
                ),
                SizedBox(width: context.dimens.xs),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey('checked'),
                          size: context.dimens.iconSm * 0.9,
                          color: primaryColor,
                        )
                      : Icon(
                          Icons.add_circle_outline_rounded,
                          key: const ValueKey('unchecked'),
                          size: context.dimens.iconSm * 0.9,
                          color: context.colors.textSecondary.withValues(alpha: 0.4),
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
