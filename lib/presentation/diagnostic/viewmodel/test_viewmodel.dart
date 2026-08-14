import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/diagnostic/entities/test_answer.dart';
import '../../../domain/diagnostic/entities/test_session.dart';
import '../../../domain/question_bank/entities/question_bank.dart';
import '../../../domain/question_bank/entities/test_question.dart';

class TestViewModel extends Notifier<TestSession> {
  @override
  TestSession build() {
    return const TestSession(
      sessionId: '',
      questions: [],
      answers: {},
      currentIndex: 0,
      status: TestSessionStatus.notStarted,
      consentAcknowledged: false,
    );
  }

  void acknowledgeConsent(bool value) {
    state = state.copyWith(consentAcknowledged: value);
  }

  /// Builds a brand-new randomized session — see [BuildTestSessionUseCase],
  /// which uses a fresh unseeded `Random()` per call so every student gets a
  /// different question set/order every time they start a test.
  void startTest(QuestionBank questionBank) {
    final buildSession = ref.read(buildTestSessionUseCaseProvider);
    final session = buildSession(
      questionBank: questionBank,
      totalQuestions: AppConfig.testQuestionCount,
      shortQuestionCount: AppConfig.testShortQuestionCount,
    );
    state = session.copyWith(
      consentAcknowledged: state.consentAcknowledged,
      status: TestSessionStatus.inProgress,
      startedAt: DateTime.now(),
    );
  }

  void answerMcq(int selectedIndex) {
    final question = state.questions[state.currentIndex];
    final mcq = question.when(mcq: (q) => q, short: (_) => null);
    if (mcq == null) return;
    _setAnswer(TestAnswer(
      questionId: mcq.id,
      chapter: mcq.chapter,
      isMcq: true,
      selectedIndex: selectedIndex,
      scoreFraction: selectedIndex == mcq.correctIndex ? 1.0 : 0.0,
    ));
  }

  void answerShort(String text) {
    final question = state.questions[state.currentIndex];
    final shortQuestion = question.when(mcq: (_) => null, short: (q) => q);
    if (shortQuestion == null) return;
    final grade = ref.read(gradeShortAnswerUseCaseProvider);
    final score = grade(studentAnswer: text, modelAnswer: shortQuestion.modelAnswer);
    _setAnswer(TestAnswer(
      questionId: shortQuestion.id,
      chapter: shortQuestion.chapter,
      isMcq: false,
      textAnswer: text,
      scoreFraction: score,
    ));
  }

  void _setAnswer(TestAnswer answer) {
    state = state.copyWith(answers: {...state.answers, answer.questionId: answer});
  }

  bool get isCurrentQuestionAnswered =>
      state.answers.containsKey(state.questions[state.currentIndex].id);

  bool get isLastQuestion => state.currentIndex == state.questions.length - 1;

  void nextQuestion() {
    if (!isCurrentQuestionAnswered || isLastQuestion) return;
    state = state.copyWith(currentIndex: state.currentIndex + 1);
  }

  void previousQuestion() {
    if (state.currentIndex == 0) return;
    state = state.copyWith(currentIndex: state.currentIndex - 1);
  }

  /// Jumping is only allowed into already-answered territory (index <=
  /// currentIndex) — forward progress past [currentIndex] always requires
  /// answering via [nextQuestion], so nothing beyond it can ever be answered.
  void jumpToQuestion(int index) {
    if (index < 0 || index > state.currentIndex) return;
    state = state.copyWith(currentIndex: index);
  }

  void submit() {
    if (state.status != TestSessionStatus.inProgress) return;
    state = state.copyWith(status: TestSessionStatus.completed);
  }

  void abandon() {
    state = state.copyWith(
      status: TestSessionStatus.notStarted,
      answers: const {},
      questions: const [],
      currentIndex: 0,
      consentAcknowledged: false,
    );
  }
}

final testViewModelProvider =
    NotifierProvider<TestViewModel, TestSession>(TestViewModel.new);
