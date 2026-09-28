import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Friendly full-screen fallback shown in place of Flutter's default
/// red/grey error screen when a widget's `build()` throws uncaught, in
/// release builds — see `ErrorWidget.builder` in `main.dart`.
///
/// Looks up [AppLocalizations] defensively (`maybeOf`, not `context.l10n`'s
/// `!`) because this can render before/around a broken ancestor, so a
/// `Localizations` ancestor isn't guaranteed to exist.
class AppCrashFallback extends StatelessWidget {
  const AppCrashFallback({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  l10n?.appCrashMessage ??
                      'Something went wrong. Please restart the app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
