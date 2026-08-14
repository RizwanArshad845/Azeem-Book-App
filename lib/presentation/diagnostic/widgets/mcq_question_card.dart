import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/radio_option_tile.dart';
import '../../../domain/question_bank/entities/mcq_question.dart';

class McqQuestionCard extends StatelessWidget {
  const McqQuestionCard({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelected,
  });

  final McqQuestion question;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  static const _letters = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question, style: context.textStyles.titleMedium),
        SizedBox(height: context.dimens.lg),
        for (var i = 0; i < question.options.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: context.dimens.sm),
            child: RadioOptionTile(
              label: question.options[i],
              selected: selectedIndex == i,
              optionLetter: i < _letters.length ? _letters[i] : null,
              onTap: () => onSelected(i),
            ),
          ),
      ],
    );
  }
}
