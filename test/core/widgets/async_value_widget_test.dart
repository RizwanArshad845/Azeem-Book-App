// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:azeem_book_app/core/widgets/async_value_widget.dart';

void main() {
  testWidgets('AsyncValueWidget renders data when data is available', (tester) async {
    const value = AsyncData<String>('Hello World');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncValueWidget<String>(
            value: value,
            data: (data) => Text(data),
          ),
        ),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('AsyncValueWidget retains previous data on refresh error', (tester) async {
    final value = AsyncError<String>('Network failure', StackTrace.empty)
        .copyWithPrevious(const AsyncData('Cached Data'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncValueWidget<String>(
            value: value,
            data: (data) => Text(data),
          ),
        ),
      ),
    );

    // Should continue showing cached data instead of error view
    expect(find.text('Cached Data'), findsOneWidget);
  });
}
