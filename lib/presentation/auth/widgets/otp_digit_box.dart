import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/context_extensions.dart';

/// Row of single-digit input boxes for OTP entry, sized by the caller from
/// `AppConfig.otpLength`. Feature-local per §2.1 (auth-only widget).
///
/// Internal focus-hopping between boxes is pure ephemeral UI state — the
/// §3 `setState` exception for local focus behavior — while the actual
/// verification call is owned by `AuthViewModel`.
class OtpDigitBox extends StatefulWidget {
  const OtpDigitBox({
    super.key,
    required this.length,
    required this.onCompleted,
    this.enabled = true,
    this.resetToken,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final bool enabled;

  /// When this value changes (e.g. a new failure instance from a rejected
  /// attempt), the boxes are cleared and refocused so the user can retype.
  final Object? resetToken;

  @override
  State<OtpDigitBox> createState() => _OtpDigitBoxState();
}

class _OtpDigitBoxState extends State<OtpDigitBox> {
  late final List<TextEditingController> _controllers = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes = List.generate(
    widget.length,
    (_) => FocusNode(),
  );

  @override
  void didUpdateWidget(covariant OtpDigitBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetToken != oldWidget.resetToken) {
      _clear();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length) {
      FocusScope.of(context).unfocus();
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i != 0) SizedBox(width: context.dimens.sm),
          SizedBox(
            width: context.dimens.iconLg + context.dimens.md,
            child: TextField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: context.textStyles.headlineSmall,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: context.dimens.sm,
                  horizontal: context.dimens.xs,
                ),
              ),
              onChanged: (value) => _onChanged(i, value),
            ),
          ),
        ],
      ],
    );
  }
}
