import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.prefixText,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.isRequired = false,
    this.enabled = true,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? prefixText;

  /// Leading icon shown inside the field, matching the icon every dropdown
  /// field (`AppDropdownCard`) already renders — kept optional since not
  /// every text field call site wants one.
  final IconData? prefixIcon;
  final TextCapitalization textCapitalization;

  /// When `true`, renders a prominent red `*` appended to [label] (CLAUDE.md
  /// teacher-onboarding rule: "Required fields marked with a prominent red
  /// asterisk"). Purely visual — this widget doesn't itself enforce
  /// required-ness; callers still validate via [errorText].
  final bool isRequired;

  /// When `false`, renders the field greyed-out and non-interactive (e.g.
  /// a phone number that can't be edited from a profile screen).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      enabled: enabled,
      decoration: InputDecoration(
        label: isRequired
            ? Text.rich(
                TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: label),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: context.colors.error),
                    ),
                  ],
                ),
              )
            : null,
        labelText: isRequired ? null : label,
        hintText: hint,
        errorText: errorText,
        prefixText: prefixText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }
}
