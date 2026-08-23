import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_button.dart';
import 'app_text_field.dart';

/// A GitHub-style destructive confirmation: the confirm button stays disabled
/// until the user types [confirmationText] exactly. Use for irreversible
/// actions (e.g. Delete Account) where a plain yes/no dialog is too weak.
/// Returns `true` only when confirmed.
Future<bool?> showTypedConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmationText,
  required String fieldLabel,
  required String confirmLabel,
  required String cancelLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => _TypedConfirmDialog(
      title: title,
      message: message,
      confirmationText: confirmationText,
      fieldLabel: fieldLabel,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}

class _TypedConfirmDialog extends StatefulWidget {
  const _TypedConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmationText,
    required this.fieldLabel,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String message;
  final String confirmationText;
  final String fieldLabel;
  final String confirmLabel;
  final String cancelLabel;

  @override
  State<_TypedConfirmDialog> createState() => _TypedConfirmDialogState();
}

class _TypedConfirmDialogState extends State<_TypedConfirmDialog> {
  final _controller = TextEditingController();
  bool _matches = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final matches = _controller.text.trim() == widget.confirmationText.trim();
      if (matches != _matches) setState(() => _matches = matches);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimens.radiusXl),
      ),
      insetPadding: EdgeInsets.all(context.dimens.lg),
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.warning_amber_rounded,
                color: context.colors.error, size: context.dimens.iconLg),
            SizedBox(height: context.dimens.sm),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: context.textStyles.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: context.dimens.sm),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimens.md),
            AppTextField(
              label: widget.fieldLabel,
              controller: _controller,
            ),
            SizedBox(height: context.dimens.lg),
            AppDangerButton(
              label: widget.confirmLabel,
              onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
            ),
            SizedBox(height: context.dimens.sm),
            AppButton(
              label: widget.cancelLabel,
              variant: AppButtonVariant.text,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}
