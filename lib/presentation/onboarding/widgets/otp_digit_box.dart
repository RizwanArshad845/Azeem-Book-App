import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/context_extensions.dart';

class OtpDigitBox extends StatelessWidget {
  const OtpDigitBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 56,
      height: 64,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            borderSide: BorderSide(
              color: hasError ? colors.error : colors.divider,
              width: hasError ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            borderSide: BorderSide(
              color: hasError ? colors.error : colors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
