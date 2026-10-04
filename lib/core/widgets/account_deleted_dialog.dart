import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/support_contact.dart';
import '../extensions/context_extensions.dart';
import 'app_dialog.dart';
import 'app_snackbar.dart';

bool _isShowing = false;

/// Blocking "Account deleted" dialog (backend `account_deleted`). Not
/// dismissible by tapping outside or the back button — the only ways out are
/// "Email support" (opens a prefilled `mailto:`) or "OK". Deliberately offers
/// no "Sign up again": signup fails with the same error for a deleted number.
///
/// Several in-flight requests can fail with this code at once; only the first
/// call shows a dialog, the rest are no-ops until it closes.
Future<void> showAccountDeletedDialog(BuildContext context) async {
  if (_isShowing) return;
  _isShowing = true;
  try {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AppDialog(
          icon: Icon(
            Icons.person_off_outlined,
            size: dialogContext.dimens.iconLg,
            color: dialogContext.colors.error,
          ),
          title: dialogContext.l10n.accountDeletedTitle,
          subtitle: dialogContext.l10n.accountDeletedMessage(kSupportEmail),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(dialogContext.l10n.commonOk),
            ),
            TextButton(
              onPressed: () => _emailSupport(dialogContext),
              child: Text(dialogContext.l10n.accountDeletedEmailSupport),
            ),
          ],
          child: const SizedBox.shrink(),
        ),
      ),
    );
  } finally {
    _isShowing = false;
  }
}

Future<void> _emailSupport(BuildContext context) async {
  final uri = Uri.parse(
    'mailto:$kSupportEmail'
    '?subject=${Uri.encodeComponent(kAccountRecoveryEmailSubject)}',
  );
  var opened = false;
  try {
    opened = await launchUrl(uri);
  } catch (_) {
    opened = false;
  }
  if (!opened && context.mounted) {
    AppSnackbar.show(
      context,
      context.l10n.accountDeletedMailFailed(kSupportEmail),
    );
  }
}
