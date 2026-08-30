import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/context_extensions.dart';

/// Shared `-`/`+` stepper for integer counts (CLAUDE.md teacher-onboarding
/// rule: "Student count widget: Integer counter input with explicit `+`/`-`
/// increment & decrement buttons"). Acts as both an interactive `-`/`+`
/// stepper AND an editable text input field.
class CounterInputField extends StatefulWidget {
  const CounterInputField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max,
    this.step = 1,
    this.isRequired = false,
    this.icon,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  /// Lower bound (inclusive). Decrement is disabled once [value] hits this.
  final int min;

  /// Upper bound (inclusive), or `null` for no ceiling. Increment is
  /// disabled once [value] hits this.
  final int? max;

  /// Amount each tap adds/subtracts.
  final int step;

  /// Mirrors [AppTextField.isRequired] — renders a red `*` after [label].
  final bool isRequired;

  /// Leading icon shown before [label], matching the icon every other
  /// onboarding field (`AppTextField.prefixIcon`, `AppDropdownCard`) renders.
  final IconData? icon;

  @override
  State<CounterInputField> createState() => _CounterInputFieldState();
}

class _CounterInputFieldState extends State<CounterInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(CounterInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final currentText = _controller.text;
      final parsedCurrent = int.tryParse(currentText);
      if (parsedCurrent != widget.value) {
        _controller.text = widget.value.toString();
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canDecrement => widget.value - widget.step >= widget.min;
  bool get _canIncrement => widget.max == null || widget.value + widget.step <= widget.max!;

  void _handleTextChange(String text) {
    if (text.isEmpty) return;
    final parsed = int.tryParse(text);
    if (parsed == null) return;

    var clamped = parsed;
    if (clamped < widget.min) clamped = widget.min;
    if (widget.max != null && clamped > widget.max!) clamped = widget.max!;
    widget.onChanged(clamped);

    // `parsed`/`clamped` strip a stray leading zero ("050" -> 50) or clamp
    // out-of-range input, but the field's own text wouldn't otherwise be
    // corrected when the clamped value happens to match `widget.value`
    // already (didUpdateWidget only rewrites text on an actual value
    // change) — so normalize display text here instead.
    final normalized = clamped.toString();
    if (text != normalized) {
      _controller.text = normalized;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: normalized.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Label-on-top-of-control, matching the caption-above-value shape both
    // [AppTextField] (floating label) and [AppDropdownCard]'s `_Label` use —
    // so this field reads as "the same position" as Name/Campus instead of
    // its own left-label/right-control row layout.
    final labelText = widget.isRequired
        ? RichText(
            text: TextSpan(
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: widget.label),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: context.colors.error),
                ),
              ],
            ),
          )
        : Text(
            widget.label,
            style: context.textStyles.labelMedium?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.icon == null
            ? labelText
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: context.dimens.iconSm,
                    color: context.colors.primary,
                  ),
                  SizedBox(width: context.dimens.xs),
                  labelText,
                ],
              ),
        SizedBox(height: context.dimens.sm),
        // Full-width pill (rather than a small left-hugging control with dead
        // space beside it) — minus/plus pinned to the edges, count centered,
        // reads as one deliberate card instead of a stray stepper.
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(context.dimens.pillRadius),
              border: Border.all(color: context.colors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepButton(
                  icon: Icons.remove,
                  onPressed: _canDecrement
                      ? () => widget.onChanged(widget.value - widget.step)
                      : null,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    onChanged: _handleTextChange,
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  onPressed: _canIncrement
                      ? () => widget.onChanged(widget.value + widget.step)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(context.dimens.sm),
          child: Icon(
            icon,
            size: context.dimens.iconSm,
            color: isDisabled
                ? context.colors.textSecondary.withValues(alpha: 0.4)
                : context.colors.primary,
          ),
        ),
      ),
    );
  }
}
