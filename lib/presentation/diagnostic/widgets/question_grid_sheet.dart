import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/test_viewmodel.dart';

class QuestionGridSheet extends ConsumerWidget {
  const QuestionGridSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(testViewModelProvider);
    final notifier = ref.read(testViewModelProvider.notifier);
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.testJumpToQuestion, style: context.textStyles.titleLarge),
          SizedBox(height: context.dimens.md),
          Wrap(
            spacing: context.dimens.sm,
            runSpacing: context.dimens.sm,
            children: List.generate(session.questions.length, (index) {
              final isAnswered = session.answers.containsKey(session.questions[index].id);
              final isCurrent = index == session.currentIndex;
              final isEnabled = index <= session.currentIndex;

              return SizedBox(
                width: 44,
                height: 44,
                child: ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                          notifier.jumpToQuestion(index);
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrent
                        ? colors.primary
                        : (isAnswered
                            ? colors.primary.withValues(alpha: 0.15)
                            : colors.surfaceVariant),
                    foregroundColor: isCurrent ? colors.onPrimary : colors.textPrimary,
                    disabledBackgroundColor: colors.surfaceVariant,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.dimens.radiusSm),
                    ),
                  ),
                  child: Text('${index + 1}'),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
