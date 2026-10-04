import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/connectivity_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/account_deleted_dialog.dart';
import 'core/widgets/offline_screen.dart';
import 'presentation/auth/viewmodel/account_deleted_viewmodel.dart';
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
            return Stack(
              children: [
                ?child,
                if (!isOnline) const Positioned.fill(child: OfflineScreen()),
              ],
            );
          },
        ),
      ),
    );
  }
}
