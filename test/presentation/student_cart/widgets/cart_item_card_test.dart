import 'package:azeem_book_app/core/theme/app_theme.dart';
import 'package:azeem_book_app/domain/catalog/entities/subject.dart';
import 'package:azeem_book_app/domain/student_cart/entities/cart_item.dart';
import 'package:azeem_book_app/l10n/app_localizations.dart';
import 'package:azeem_book_app/presentation/student_cart/widgets/cart_item_card.dart';
import 'package:azeem_book_app/presentation/student_home/viewmodel/student_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestWidget({
  required CartItem item,
  required VoidCallback onRemove,
  List<dynamic> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CartItemCard(
          item: item,
          onRemove: onRemove,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('CartItemCard displays subjectName when present instead of subjectId',
      (tester) async {
    const item = CartItem(
      id: 'cart_item_1',
      subjectId: 'subj_physics_101',
      subjectName: 'Physics',
      testCount: 5,
      price: 1000,
    );

    await tester.pumpWidget(
      _buildTestWidget(
        item: item,
        onRemove: () {},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Physics'), findsOneWidget);
    expect(find.text('subj_physics_101'), findsNothing);
    expect(find.text('5 tests'), findsOneWidget);
    expect(find.text('Rs. 1000'), findsOneWidget);
  });

  testWidgets(
      'CartItemCard resolves subjectName from subjectByIdProvider when item.subjectName is null',
      (tester) async {
    const item = CartItem(
      id: 'cart_item_2',
      subjectId: 'subj_cs_101',
      subjectName: null,
      price: 1500,
      discountedPrice: 1200,
    );

    await tester.pumpWidget(
      _buildTestWidget(
        item: item,
        onRemove: () {},
        overrides: [
          subjectByIdProvider('subj_cs_101').overrideWith(
            (ref) => Future.value(
              const Subject(
                id: 'subj_cs_101',
                boardClassId: 'bc_1',
                name: 'Computer Science',
                bundlePrice: 1500,
              ),
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Computer Science'), findsOneWidget);
    expect(find.text('subj_cs_101'), findsNothing);
    expect(find.text('Rs. 1500'), findsOneWidget);
    expect(find.text('Rs. 1200'), findsOneWidget);
  });

  testWidgets('CartItemCard triggers onRemove when close button is tapped',
      (tester) async {
    var removed = false;
    const item = CartItem(
      id: 'cart_item_3',
      subjectId: 'subj_math_101',
      subjectName: 'Mathematics',
      price: 800,
    );

    await tester.pumpWidget(
      _buildTestWidget(
        item: item,
        onRemove: () => removed = true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mathematics'), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    expect(removed, isTrue);
  });
}
