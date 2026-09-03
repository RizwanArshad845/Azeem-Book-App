import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/test_taking/entities/attempt_question.dart';

/// Renders a single mcq [AttemptQuestion] as tappable radio-style option rows
/// (project_spec.md §10.1 — cards for scannable data, shared widget kit
/// only, `context.colors`/`context.dimens`, no per-screen bespoke variant).
class McqQuestionCard extends StatelessWidget {
  const McqQuestionCard({
    super.key,
    required this.question,
    required this.selectedOptionIndex,
    required this.onSelect,
  });

  final AttemptQuestion question;
  final int? selectedOptionIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final options = question.options ?? const <String>[];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.questionText, style: context.textStyles.bodyLarge),
          SizedBox(height: context.dimens.md),
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: context.dimens.sm),
              child: _OptionRow(
                label: options[i],
                selected: selectedOptionIndex == i,
                onTap: () => onSelect(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.dimens.radiusMd);
    final color = selected ? context.colors.primary : context.colors.divider;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: EdgeInsets.all(context.dimens.sm),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: selected ? 2 : 1),
            borderRadius: radius,
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? context.colors.primary : context.colors.textSecondary,
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(child: Text(label, style: context.textStyles.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
