import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class RadioOptionTile extends StatelessWidget {
  const RadioOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.optionLetter,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? optionLetter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dimens.radiusMd),
      child: Container(
        padding: EdgeInsets.all(dimens.md),
        decoration: BoxDecoration(
          color: selected ? colors.primary.withValues(alpha: 0.08) : colors.surface,
          borderRadius: BorderRadius.circular(dimens.radiusMd),
          border: Border.all(
            color: selected ? colors.primary : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (optionLetter != null) ...[
              CircleAvatar(
                radius: 14,
                backgroundColor: selected ? colors.primary : colors.surfaceVariant,
                foregroundColor: selected ? colors.onPrimary : colors.textSecondary,
                child: Text(optionLetter!, style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(width: dimens.sm),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
