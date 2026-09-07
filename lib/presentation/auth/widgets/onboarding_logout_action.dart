import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../viewmodel/auth_viewmodel.dart';

/// Shared confirm-then-logout action for every onboarding screen
/// (`OnboardingScaffold.onLogout`) — an authenticated-but-not-yet-onboarded
/// session otherwise has no self-service way out, since the router always
/// resumes it back into onboarding. Mirrors
/// `StudentProfileView._handleLogout` verbatim (same dialog, same l10n
/// strings, same fire-and-forget `logout()` — the router redirect handles
/// navigation once the session goes null).
Future<void> confirmOnboardingLogout(BuildContext context, WidgetRef ref) async {
  final confirmed = await confirmDialog(
    context,
    title: context.l10n.profileLogoutConfirmTitle,
    message: context.l10n.profileLogoutConfirmMessage,
    confirmLabel: context.l10n.profileLogout,
    isDestructive: true,
  );
  if (confirmed != true) return;
  ref.read(authViewModelProvider.notifier).logout();
}
