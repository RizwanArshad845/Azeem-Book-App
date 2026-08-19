import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/section_progress_indicator.dart';
import '../../../domain/catalog/entities/question.dart';
import '../viewmodel/test_taking_state.dart';
import '../viewmodel/test_taking_viewmodel.dart';
import 'mcq_question_card.dart';
import 'short_answer_question_card.dart';
import 'test_navigation_buttons.dart';
import 'timer_label.dart';

class QuestionBody extends ConsumerWidget {
  const QuestionBody({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(
      testTakingViewModelProvider(testId).select((async) {
        final s = async.value;
        if (s == null) return null;
        return (
          status: s.status,
          currentIndex: s.currentIndex,
          questions: s.questions,
          answers: s.answers,
        );
      }),
    );
    if (snapshot == null || snapshot.questions.isEmpty) {
      return EmptyStateView(message: context.l10n.testNoQuestionsFound);
    }

    final vm = ref.read(testTakingViewModelProvider(testId).notifier);
    final question = snapshot.questions[snapshot.currentIndex];
    final isLast = snapshot.currentIndex == snapshot.questions.length - 1;
    final isSubmitting = snapshot.status == TestTakingStatus.submitting;
    final currentAnswer = snapshot.answers[question.id];

    return Padding(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.testProgressLabel(
                  snapshot.currentIndex + 1,
                  snapshot.questions.length,
                ),
                style: context.textStyles.titleMedium,
              ),
              TimerLabel(testId: testId),
            ],
          ),
          SizedBox(height: context.dimens.sm),
          SectionProgressIndicator(
            currentStep: snapshot.currentIndex,
            totalSteps: snapshot.questions.length,
          ),
          SizedBox(height: context.dimens.lg),
          Expanded(
            child: SingleChildScrollView(
              child: question.type == QuestionType.mcq
                  ? McqQuestionCard(
                      question: question,
                      selectedOptionIndex: currentAnswer?.selectedOptionIndex,
                      onSelect: (index) => vm.selectOption(question.id, index),
                    )
                  : ShortAnswerQuestionCard(
                      question: question,
                      answerText: currentAnswer?.answerText,
                      onChanged: (text) => vm.setTextAnswer(question.id, text),
                    ),
            ),
          ),
          SizedBox(height: context.dimens.md),
          TestNavigationButtons(
            showPrevious: snapshot.currentIndex > 0,
            isLastQuestion: isLast,
            isSubmitting: isSubmitting,
            onPrevious: vm.previousQuestion,
            onNext: vm.nextQuestion,
            onSubmit: () async {
              final attempt = await vm.submitAttempt();
              if (attempt == null && context.mounted) {
                AppSnackbar.show(context, context.l10n.testSubmitFailed);
              }
            },
          ),
        ],
      ),
    );
  }
}
