import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';

/// Feature-local multi-select control (classes / subjects pickers) — no
/// equivalent exists in the shared widget kit (§10.1 enumerates `AppButton`,
/// `AppTextField`, `AppDropdown`, `AppCard`, etc., none of which cover
/// multi-select), so this lives under `presentation/teacher_onboarding/widgets`
/// per §2.1 rather than inventing a one-off inline layout. Built from
/// `AppCard` + Material `FilterChip` so it still only uses
/// `context.colors`/`context.dimens`, never hardcoded values.
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
  });

  final String label;
  final List<T> options;
  final String Function(T option) optionLabel;
  final String Function(T option) optionId;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyles.labelLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimens.sm),
          if (options.isEmpty)
            Text(
              emptyMessage ?? 'Nothing to select yet.',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            )
          else
            Wrap(
              spacing: context.dimens.sm,
              runSpacing: context.dimens.sm,
              children: [
                for (final option in options)
                  FilterChip(
                    label: Text(optionLabel(option)),
                    selected: selectedIds.contains(optionId(option)),
                    selectedColor: context.colors.primary.withValues(
                      alpha: 0.16,
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
      ),
    );
  }
}
