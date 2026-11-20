import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extensions.dart';
import '../providers/connectivity_provider.dart';
import 'app_button.dart';
import 'app_logo.dart';

/// Full-screen "you're offline" screen, shown over the whole app (by `App`)
/// for as long as the device has no connection and removed automatically once
/// it's back — so whatever the user was doing underneath is still there.
///
/// Kept deliberately plain: logo, a wifi-off badge, one sentence, one
/// "Try again" button (connectivity is also re-checked in the background).
/// [footer] is optional extra content below — the app passes the
/// "My downloaded books" card so a student can keep reading offline.
class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key, this.footer});

  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimens = context.dimens;
    final colors = context.colors;
    // Back must not reach the routes hidden underneath.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(dimens.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: dimens.contentMaxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo(size: 56)),
                    SizedBox(height: dimens.xl),
                    Center(
                      child: Container(
                        width: dimens.avatarLg * 1.4,
                        height: dimens.avatarLg * 1.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary.withValues(alpha: 0.10),
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          color: colors.primary,
                          size: dimens.iconLg * 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: dimens.lg),
                    Text(
                      context.l10n.offlineTitle,
                      textAlign: TextAlign.center,
                      style: context.textStyles.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: dimens.sm),
                    Text(
                      context.l10n.offlineMessage,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: dimens.lg),
                    AppButton(
                      label: context.l10n.offlineTryAgain,
                      icon: Icons.refresh_rounded,
                      onPressed: () =>
                          ref.read(isOnlineProvider.notifier).recheck(),
                    ),
                    SizedBox(height: dimens.sm),
                    Text(
                      context.l10n.offlineCheckingAgain,
                      textAlign: TextAlign.center,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    if (footer != null) ...[
                      SizedBox(height: dimens.xl),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
