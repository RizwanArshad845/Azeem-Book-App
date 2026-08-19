import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_dialog.dart';

/// Shared yes/no confirmation dialog for actions that shouldn't fire on a
/// single tap (delete account, leave an in-progress test, etc.). Returns
/// `true` only if the user picked [confirmLabel]; `false`/`null` (dismissed)
/// otherwise.
Future<bool?> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Confirm',
  bool isDestructive = false,
}) {
  return AppDialog.show<bool>(
    context: context,
    title: title,
    subtitle: message,
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(cancelLabel),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          confirmLabel,
          style: isDestructive
              ? TextStyle(color: context.colors.error)
              : null,
        ),
      ),
    ],
    child: const SizedBox.shrink(),
  );
}
