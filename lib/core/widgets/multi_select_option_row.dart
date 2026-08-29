import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// Selectable checkbox-card row for a multi-select list (e.g. subjects a
/// student wants, classes/subjects a teacher teaches) — generalized from
/// the old subject-specific `SubjectRow` so any multi-select onboarding
/// step can share one widget instead of each inventing its own near-
/// identical row (mirrors [CatalogOptionRow]'s single-select equivalent,
/// this project's shared-widget-reuse convention).
class MultiSelectOptionRow extends StatelessWidget {
  const MultiSelectOptionRow({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelectedChanged,
    this.icon,
    this.trailing,
    this.expandedContent,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;

  /// Optional leading native icon (CLAUDE.md mandates native icons over
  /// text-only rows where a per-item icon is available).
  final IconData? icon;

  /// Optional content rendered at the row's trailing edge (e.g. a badge).
  final Widget? trailing;

  /// Optional extra content shown below the row once selected (e.g. a
  /// nested picker) — only rendered when non-null, callers gate it on
  /// [isSelected] themselves.
  final Widget? expandedContent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => onSelectedChanged(!isSelected),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) => onSelectedChanged(value ?? false),
              ),
              if (icon != null) ...[
                Icon(
                  icon,
                  size: context.dimens.iconMd,
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.textSecondary,
                ),
                SizedBox(width: context.dimens.sm),
              ],
              Expanded(
                child: Text(label, style: context.textStyles.bodyLarge),
              ),
              ?trailing,
            ],
          ),
          if (expandedContent != null) ...[
            SizedBox(height: context.dimens.sm),
            expandedContent!,
          ],
        ],
      ),
    );
  }
}
