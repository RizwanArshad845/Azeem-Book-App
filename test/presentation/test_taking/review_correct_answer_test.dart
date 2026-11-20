import 'package:azeem_book_app/domain/test_taking/entities/submission_answer.dart';
import 'package:azeem_book_app/presentation/test_taking/widgets/review_answers_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('server-provided correct option text wins', () {
    const answer = SubmissionAnswer(
      questionId: 'q',
      options: ['A', 'B'],
      correctOptionIndex: 0,
      correctOptionText: 'B-text',
    );
    expect(correctAnswerText(answer), 'B-text');
  });

  test('indexes the stored-order result options, not the shuffled ones', () {
    const answer = SubmissionAnswer(
      questionId: 'q',
      options: ['alpha', 'beta', 'gamma'],
      correctOptionIndex: 2,
    );
    expect(correctAnswerText(answer), 'gamma');
  });

  test(
    'option-answered short question prefers the option over expectedAnswer',
    () {
      const answer = SubmissionAnswer(
        questionId: 'q',
        options: ['ایک', 'دو'],
        correctOptionIndex: 1,
        expectedAnswer: 'free text key',
      );
      expect(correctAnswerText(answer), 'دو');
    },
  );

  test('text-answered question shows expectedAnswer', () {
    const answer = SubmissionAnswer(questionId: 'q', expectedAnswer: 'F = ma');
    expect(correctAnswerText(answer), 'F = ma');
  });

  test('older response with only an index falls back to a label', () {
    const answer = SubmissionAnswer(questionId: 'q', correctOptionIndex: 1);
    expect(correctAnswerText(answer), 'Option 2');
  });
}
