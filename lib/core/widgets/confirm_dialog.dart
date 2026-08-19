import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

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
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            confirmLabel,
            style: isDestructive
                ? TextStyle(color: dialogContext.colors.error)
                : null,
          ),
        ),
      ],
    ),
  );
}
