import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/question_bank/entities/test_question.dart';
import '../viewmodel/test_timer_viewmodel.dart';
import '../viewmodel/test_viewmodel.dart';
import '../widgets/countdown_timer_bar.dart';
import '../widgets/mcq_question_card.dart';
import '../widgets/question_grid_sheet.dart';
import '../widgets/rec_indicator.dart';
import '../widgets/short_question_card.dart';

class TestView extends ConsumerWidget {
  const TestView({super.key});

  Future<void> _handleBackButton(BuildContext context, WidgetRef ref) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.testExitDialogTitle),
        content: Text(context.l10n.testExitDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.testExitDialogConfirm),
          ),
        ],
      ),
    );

    if (shouldLeave == true) {
      ref.read(testTimerViewModelProvider.notifier).stop();
      ref.read(testViewModelProvider.notifier).abandon();
      if (context.mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(testViewModelProvider);
    final notifier = ref.read(testViewModelProvider.notifier);

    if (session.questions.isEmpty) {
      return const Scaffold(body: LoadingIndicator());
    }

    final question = session.questions[session.currentIndex];
    final answer = session.answers[question.id];
    final isAnswered = answer != null;
    final isLast = session.currentIndex == session.questions.length - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackButton(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.testProgressLabel(session.currentIndex + 1, session.questions.length),
          ),
          actions: [
            if (session.consentAcknowledged) const RecIndicator(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.dimens.md),
              child: const Center(child: CountdownTimerBar()),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => const QuestionGridSheet(),
                  ),
                  icon: const Icon(Icons.grid_view_rounded),
                  label: Text(context.l10n.testJumpToQuestion),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: question.when(
                    mcq: (mcq) => McqQuestionCard(
                      question: mcq,
                      selectedIndex: answer?.selectedIndex,
                      onSelected: notifier.answerMcq,
                    ),
                    short: (short) => ShortQuestionCard(
                      key: ValueKey(short.id),
                      question: short,
                      initialText: answer?.textAnswer ?? '',
                      onChanged: notifier.answerShort,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.dimens.md),
              Row(
                children: [
                  if (session.currentIndex > 0) ...[
                    Expanded(
                      child: AppButton(
                        label: context.l10n.testPreviousButton,
                        variant: AppButtonVariant.outlined,
                        onPressed: notifier.previousQuestion,
                      ),
                    ),
                    SizedBox(width: context.dimens.md),
                  ],
                  Expanded(
                    child: AppButton(
                      label: isLast
                          ? context.l10n.testSubmitButton
                          : context.l10n.testNextButton,
                      onPressed: isAnswered
                          ? () {
                              if (isLast) {
                                ref.read(testTimerViewModelProvider.notifier).stop();
                                notifier.submit();
                                context.go(AppRoutes.diagnosticResults);
                              } else {
                                notifier.nextQuestion();
                              }
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
