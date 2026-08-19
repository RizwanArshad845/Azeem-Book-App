import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/catalog/entities/question.dart';

/// Renders a `shortAnswer`/`longAnswer` [Question] — same UI for both (a
/// single free-text field), only the label/line-count differ, per the task
/// brief ("reuse one widget with a text field for both short/long since UI
/// is identical").
class ShortAnswerQuestionCard extends StatefulWidget {
  const ShortAnswerQuestionCard({
    super.key,
    required this.question,
    required this.answerText,
    required this.onChanged,
  });

  final Question question;
  final String? answerText;
  final ValueChanged<String> onChanged;

  @override
  State<ShortAnswerQuestionCard> createState() =>
      _ShortAnswerQuestionCardState();
}

class _ShortAnswerQuestionCardState extends State<ShortAnswerQuestionCard> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.answerText,
  );

  @override
  void didUpdateWidget(covariant ShortAnswerQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Question changed (navigated to a different question) — resync the
    // controller's ephemeral text to that question's stored answer.
    if (oldWidget.question.id != widget.question.id) {
      _controller.text = widget.answerText ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLong = widget.question.type == QuestionType.longAnswer;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.question.questionText, style: context.textStyles.bodyLarge),
          SizedBox(height: context.dimens.md),
          AppTextField(
            label: isLong
                ? context.l10n.testAnswerLongLabel
                : context.l10n.testAnswerShortLabel,
            controller: _controller,
            maxLines: isLong ? 8 : 3,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
