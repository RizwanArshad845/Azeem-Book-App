import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/connectivity_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/extensions/context_extensions.dart';
import 'core/widgets/account_deleted_dialog.dart';
import 'core/widgets/blocking_loader_overlay.dart';
import 'core/widgets/offline_screen.dart';
import 'presentation/auth/viewmodel/account_deleted_viewmodel.dart';
import 'presentation/auth/viewmodel/auth_viewmodel.dart';
import 'presentation/ebook_reader/offline_reader_presence.dart';
import 'presentation/ebook_reader/widgets/downloaded_books_card.dart';
import 'presentation/student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import 'l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final locale = ref.watch(localeProvider);

    // Backend `account_deleted` (login/signup 403, or 401 on a normal call):
    // blocking dialog on the root navigator. Session clearing and the return
    // to login for the 401 case are handled in `main.dart`'s callback.
    ref.listen<int>(accountDeletedEventProvider, (previous, next) {
      final dialogContext = rootNavigatorKey.currentContext;
      if (dialogContext != null) showAccountDeletedDialog(dialogContext);
    });

    return MaterialApp.router(
      title: 'Azeem Publications',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Tap anywhere outside a focused input to dismiss the keyboard —
      // applied once here rather than per-screen so every form in the app
      // gets it for free.
      builder: (context, child) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        // The offline screen sits on top of the whole app (not pushed onto the
        // router), so the user's place — and any in-progress test — is intact
        // underneath and it disappears the moment the connection returns.
        // A Consumer keeps the connectivity watch from rebuilding the whole
        // `MaterialApp.router`.
        child: Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(isOnlineProvider);
            ref.listen<bool>(isOnlineProvider, (wasOnline, online) {
              if (!online) {
                // Drop the keyboard of a field hidden under the overlay.
                FocusManager.instance.primaryFocus?.unfocus();
              } else if (wasOnline == false &&
                  ref.read(studentOnboardingViewModelProvider).hasError) {
                // Cold start offline left the student record unfetched (the
                // router is holding on splash) — retry now we're back.
                ref.invalidate(studentOnboardingViewModelProvider);
              }
            });
            // Offline-safe screens (downloaded books, offline reader) work
            // with no connection, so the overlay steps aside while any of
            // them is open.
            return ValueListenableBuilder<int>(
              valueListenable: offlineSafeScreens,
              builder: (context, safeScreens, _) {
                return Stack(
                  children: [
                    ?child,
                    if (!isOnline && safeScreens == 0)
                      const Positioned.fill(
                        child: OfflineScreen(footer: DownloadedBooksCard()),
                      ),
                    const Positioned.fill(child: _AuthBusyLayer()),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Blocking "Signing you in…" / "Logging you out…" loader over the whole
/// app, whichever screen started it. Watches only `authBusyProvider`, so it
/// rebuilds alone.
class _AuthBusyLayer extends ConsumerWidget {
  const _AuthBusyLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(authBusyProvider);
    final l10n = context.l10n;
    final (message, hint) = switch (busy) {
      AuthBusy.none => (null, null),
      AuthBusy.signingIn => (l10n.authBusySigningIn, l10n.authBusySigningInHint),
      AuthBusy.loggingOut => (
        l10n.authBusyLoggingOut,
        l10n.authBusyLoggingOutHint,
      ),
    };
    // Never intercept taps while idle (or while fading out).
    return IgnorePointer(
      ignoring: message == null,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: message == null
            ? const SizedBox.shrink()
            : BlockingLoaderOverlay(
                key: ValueKey(busy),
                message: message,
                hint: hint,
              ),
      ),
    );
  }
}
