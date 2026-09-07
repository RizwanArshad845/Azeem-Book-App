// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:azeem_book_app/core/widgets/async_value_widget.dart';
import 'package:azeem_book_app/core/widgets/delayed_loader.dart';

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

  testWidgets(
    'AsyncValueWidget shows a loading state on retry when there is no '
    'cached data yet — a Retry tap must be visible, not indistinguishable '
    'from a no-op',
    (tester) async {
      final errorNoData = AsyncError<String>(
        'Network failure',
        StackTrace.empty,
      );
      // Mirrors Riverpod's actual internal `ref.invalidate`/`ref.refresh`
      // path (`AsyncLoading.copyWithPrevious`, riverpod 3.4.2): the
      // resulting state stays an `AsyncError` (not `AsyncLoading`), with
      // `isRefreshing: true` and no attached value.
      final refreshingState = const AsyncLoading<String>().copyWithPrevious(
        errorNoData,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncValueWidget<String>(
              value: refreshingState,
              data: (data) => Text(data),
            ),
          ),
        ),
      );

      expect(find.byType(DelayedLoader), findsOneWidget);
      expect(find.text('Network failure'), findsNothing);
    },
  );
}
