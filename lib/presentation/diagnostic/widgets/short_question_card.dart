import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/question_bank/entities/short_question.dart';

/// Owns its own [TextEditingController] seeded from [initialText] so the
/// parent doesn't need to manage per-question controller lifecycles — give
/// this widget a `ValueKey(question.id)` from the caller so Flutter
/// recreates it (and re-seeds the controller) when the question changes.
class ShortQuestionCard extends StatefulWidget {
  const ShortQuestionCard({
    super.key,
    required this.question,
    required this.initialText,
    required this.onChanged,
  });

  final ShortQuestion question;
  final String initialText;
  final ValueChanged<String> onChanged;

  @override
  State<ShortQuestionCard> createState() => _ShortQuestionCardState();
}

class _ShortQuestionCardState extends State<ShortQuestionCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question.question, style: context.textStyles.titleMedium),
        SizedBox(height: context.dimens.lg),
        AppTextField(
          label: context.l10n.testShortAnswerHint,
          controller: _controller,
          onChanged: widget.onChanged,
          maxLines: 8,
        ),
      ],
    );
  }
}
