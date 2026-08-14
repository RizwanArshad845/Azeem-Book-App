import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../domain/onboarding/entities/class_level.dart';

class ClassLevelSegmentedControl extends StatelessWidget {
  const ClassLevelSegmentedControl({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ClassLevel? selected;
  final ValueChanged<ClassLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: context.dimens.sm,
      runSpacing: context.dimens.sm,
      children: ClassLevel.values.map((level) {
        final isSelected = selected == level;
        return ChoiceChip(
          label: Text(level.label),
          selected: isSelected,
          onSelected: (_) => onChanged(level),
          selectedColor: colors.primary,
          labelStyle: TextStyle(
            color: isSelected ? colors.onPrimary : colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: colors.surface,
          side: BorderSide(color: isSelected ? colors.primary : colors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimens.radiusMd),
          ),
        );
      }).toList(),
    );
  }
}
