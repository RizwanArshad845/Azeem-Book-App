import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';

class SubjectRow extends StatelessWidget {
  const SubjectRow({
    super.key,
    required this.subjectName,
    required this.isSelected,
    required this.onSelectedChanged,
    required this.teacherPicker,
    required this.discountApplied,
  });

  final String subjectName;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;
  final Widget? teacherPicker;
  final bool discountApplied;

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
              Expanded(
                child: Text(subjectName, style: context.textStyles.bodyLarge),
              ),
              if (discountApplied)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.sm,
                    vertical: context.dimens.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(context.dimens.pillRadius),
                  ),
                  child: Text(
                    context.l10n.subjectTeacherSelectDiscountApplied,
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.success,
                    ),
                  ),
                ),
            ],
          ),
          if (teacherPicker != null) ...[
            SizedBox(height: context.dimens.sm),
            teacherPicker!,
          ],
        ],
      ),
    );
  }
}
