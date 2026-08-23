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
          canGoNext: s.canGoNext,
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
          SizedBox(height: context.dimens.sm),
          _QuestionTypeBadge(type: question.type),
          SizedBox(height: context.dimens.md),
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
            canGoNext: snapshot.canGoNext,
            onPrevious: vm.previousQuestion,
            onNext: vm.nextQuestion,
            onSubmit: () async {
              if (!snapshot.canGoNext) return;
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

/// Small icon/badge near the question header identifying its type — mcq,
/// short answer, or long answer (Workstream 6 icon vocabulary).
class _QuestionTypeBadge extends StatelessWidget {
  const _QuestionTypeBadge({required this.type});

  final QuestionType type;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (type) {
      QuestionType.mcq => (
        Icons.radio_button_checked,
        context.l10n.testQuestionTypeMcq,
      ),
      QuestionType.shortAnswer => (
        Icons.short_text,
        context.l10n.testQuestionTypeShortAnswer,
      ),
      QuestionType.longAnswer => (
        Icons.notes,
        context.l10n.testQuestionTypeLongAnswer,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.dimens.iconSm, color: context.colors.primary),
        SizedBox(width: context.dimens.xs),
        Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
