import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extensions.dart';
import '../providers/connectivity_provider.dart';
import 'app_error_view.dart';

/// Full-screen "you're offline" screen, shown over the whole app (by `App`)
/// for as long as the device has no connection and removed automatically once
/// it's back — so whatever the user was doing underneath is still there.
class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.dimens.contentMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.offlineTitle,
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppErrorView(
                  isOffline: true,
                  message: context.l10n.offlineMessage,
                  onRetry: () => ref.read(isOnlineProvider.notifier).recheck(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
