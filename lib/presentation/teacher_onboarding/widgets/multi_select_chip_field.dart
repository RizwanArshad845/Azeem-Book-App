import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Feature-local multi-select control (classes / subjects pickers) —
/// renders a clean labeled set of Material `FilterChip`s styled via
/// `context.colors`/`context.dimens`.
class MultiSelectChipField<T> extends StatelessWidget {
  const MultiSelectChipField({
    super.key,
    required this.label,
    required this.options,
    required this.optionLabel,
    required this.optionId,
    required this.selectedIds,
    required this.onChanged,
    this.emptyMessage,
    this.isRequired = false,
  });

  final String label;
  final List<T> options;
  final String Function(T option) optionLabel;
  final String Function(T option) optionId;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final String? emptyMessage;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired
            ? RichText(
                text: TextSpan(
                  style: context.textStyles.labelLarge?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  children: [
                    TextSpan(text: label),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: context.colors.error),
                    ),
                  ],
                ),
              )
            : Text(
                label,
                style: context.textStyles.labelLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
        SizedBox(height: context.dimens.xs),
        if (options.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.dimens.xs),
            child: Text(
              emptyMessage ?? 'Nothing to select yet.',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          )
        else
          Wrap(
            spacing: context.dimens.xs,
            runSpacing: context.dimens.xs,
            children: [
              for (final option in options)
                FilterChip(
                  label: Text(
                    optionLabel(option),
                    style: context.textStyles.bodySmall?.copyWith(
                      fontWeight: selectedIds.contains(optionId(option))
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selectedIds.contains(optionId(option))
                          ? context.colors.primary
                          : context.colors.textPrimary,
                    ),
                  ),
                  selected: selectedIds.contains(optionId(option)),
                  selectedColor: context.colors.primary.withValues(
                    alpha: 0.14,
                  ),
                  side: BorderSide(
                    color: selectedIds.contains(optionId(option))
                        ? context.colors.primary
                        : context.colors.divider,
                  ),
                  checkmarkColor: context.colors.primary,
                  onSelected: (isSelected) {
                    final next = Set<String>.of(selectedIds);
                    if (isSelected) {
                      next.add(optionId(option));
                    } else {
                      next.remove(optionId(option));
                    }
                    onChanged(next);
                  },
                ),
            ],
          ),
      ],
    );
  }
}
