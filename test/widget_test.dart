import 'package:azeem_book_app/app.dart';
import 'package:azeem_book_app/core/di/injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots to splash screen', (WidgetTester tester) async {
    setupLocator();

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();

    expect(find.byType(App), findsOneWidget);
  });
}
