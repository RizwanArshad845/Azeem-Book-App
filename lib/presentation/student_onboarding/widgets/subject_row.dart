import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/multi_select_option_row.dart';

/// Subject-flavored wrapper around the shared [MultiSelectOptionRow] —
/// keeps this call site's existing `subjectName`/`teacherPicker`/
/// `discountApplied` API so student onboarding's selection logic is
/// untouched, while the actual row chrome lives in one shared widget.
class SubjectRow extends StatelessWidget {
  const SubjectRow({
    super.key,
    required this.subjectName,
    required this.isSelected,
    required this.onSelectedChanged,
    this.teacherPicker,
    this.discountApplied = false,
  });

  final String subjectName;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;
  final Widget? teacherPicker;
  final bool discountApplied;

  @override
  Widget build(BuildContext context) {
    return MultiSelectOptionRow(
      label: subjectName,
      isSelected: isSelected,
      onSelectedChanged: onSelectedChanged,
      trailing: discountApplied
          ? Container(
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
            )
          : null,
      expandedContent: teacherPicker,
    );
  }
}
