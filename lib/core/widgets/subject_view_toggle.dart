import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'press_scale.dart';

/// Two-way list/grid layout toggle for the Subjects screen. A small pill with
/// two icon segments; the selected one gets the brand-primary fill.
enum SubjectViewMode { list, grid }

class SubjectViewToggle extends StatelessWidget {
  const SubjectViewToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final SubjectViewMode mode;
  final ValueChanged<SubjectViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dimens.xs),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(context.dimens.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segment(context, SubjectViewMode.list, Icons.view_agenda_outlined),
          _segment(context, SubjectViewMode.grid, Icons.grid_view_rounded),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, SubjectViewMode value, IconData icon) {
    final selected = mode == value;
    return PressScale(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(context.dimens.sm),
          decoration: BoxDecoration(
            color: selected ? context.colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(context.dimens.pillRadius),
          ),
          child: Icon(
            icon,
            size: context.dimens.iconMd,
            color: selected ? context.colors.onPrimary : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
