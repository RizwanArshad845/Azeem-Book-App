import 'package:azeem_book_app/core/theme/app_theme.dart';
import 'package:azeem_book_app/core/widgets/onboarding_scaffold.dart';
import 'package:azeem_book_app/core/widgets/section_progress_indicator.dart';
import 'package:azeem_book_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  testWidgets(
    'OnboardingScaffold shows a logout action and invokes onLogout when '
    'tapped — otherwise a not-yet-onboarded session has no way out',
    (tester) async {
      var loggedOut = false;

      await tester.pumpWidget(
        _wrap(
          OnboardingScaffold(
            onLogout: () => loggedOut = true,
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byIcon(Icons.logout), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      expect(loggedOut, isTrue);
    },
  );

  testWidgets(
    'OnboardingScaffold does not show a logout action when onLogout is null',
    (tester) async {
      await tester.pumpWidget(
        _wrap(OnboardingScaffold(child: const SizedBox.shrink())),
      );

      expect(find.byIcon(Icons.logout), findsNothing);
    },
  );

  testWidgets(
    'OnboardingScaffold renders SectionProgressIndicator when currentStep and totalSteps are provided',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          OnboardingScaffold(
            currentStep: 2,
            totalSteps: 3,
            onLogout: () {},
            child: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(SectionProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    },
  );
}
