import 'package:azeem_book_app/core/widgets/urdu_aware_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('containsUrdu', () {
    test('matches Urdu script', () => expect(containsUrdu('پاکستان'), isTrue));
    test('matches Urdu inside English text', () {
      expect(containsUrdu('Translate: کتاب'), isTrue);
    });
    test('ignores Latin text and digits', () {
      expect(containsUrdu('Newton’s 2nd law, F = ma'), isFalse);
    });
  });

  testWidgets('non-Urdu text renders as a plain left-to-right Text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UrduAwareText('Physics'))),
    );
    final text = tester.widget<Text>(find.text('Physics'));
    expect(text.textDirection, isNull);
    expect(text.style?.fontFamily, isNot(urduFontFamily));
  });
}
