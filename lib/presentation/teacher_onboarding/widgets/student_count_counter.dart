import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/context_extensions.dart';

/// Interactive counter widget for selecting approximate student count.
/// Supports +/- steppers, direct text typing, and quick preset buttons.
class StudentCountCounter extends StatefulWidget {
  const StudentCountCounter({
    super.key,
    required this.count,
    required this.onChanged,
  });

  final int? count;
  final ValueChanged<int?> onChanged;

  @override
  State<StudentCountCounter> createState() => _StudentCountCounterState();
}

class _StudentCountCounterState extends State<StudentCountCounter> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.count != null ? widget.count.toString() : '',
    );
  }

  @override
  void didUpdateWidget(covariant StudentCountCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      final textVal = widget.count != null ? widget.count.toString() : '';
      if (_controller.text != textVal) {
        _controller.text = textVal;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment([int step = 5]) {
    final current = widget.count ?? 0;
    final next = current + step;
    widget.onChanged(next);
  }

  void _decrement([int step = 5]) {
    final current = widget.count ?? 0;
    final next = (current - step).clamp(0, 99999);
    widget.onChanged(next == 0 ? null : next);
  }

  void _setCount(int val) {
    widget.onChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.count ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CounterButton(
              icon: Icons.remove_rounded,
              onPressed: count > 0 ? () => _decrement(1) : null,
            ),
            SizedBox(width: context.dimens.md),
            Container(
              width: 120,
              padding: EdgeInsets.symmetric(
                vertical: context.dimens.sm,
                horizontal: context.dimens.md,
              ),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                border: Border.all(
                  color: widget.count != null
                      ? context.colors.primary
                      : context.colors.divider,
                  width: widget.count != null ? 1.5 : 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: context.textStyles.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.count != null
                      ? context.colors.primary
                      : context.colors.textSecondary,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: context.textStyles.headlineSmall?.copyWith(
                    color: context.colors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val.trim());
                  widget.onChanged(parsed);
                },
              ),
            ),
            SizedBox(width: context.dimens.md),
            _CounterButton(
              icon: Icons.add_rounded,
              onPressed: () => _increment(1),
            ),
          ],
        ),
        SizedBox(height: context.dimens.md),
        Text(
          'Quick Presets',
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.dimens.xs),
        Wrap(
          spacing: context.dimens.sm,
          runSpacing: context.dimens.xs,
          alignment: WrapAlignment.center,
          children: [
            for (final preset in const [20, 50, 100, 200, 500])
              ActionChip(
                label: Text('$preset+'),
                labelStyle: context.textStyles.bodySmall?.copyWith(
                  color: widget.count == preset
                      ? context.colors.primary
                      : context.colors.textPrimary,
                  fontWeight: widget.count == preset
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                backgroundColor: widget.count == preset
                    ? context.colors.primary.withValues(alpha: 0.15)
                    : context.colors.surface,
                side: BorderSide(
                  color: widget.count == preset
                      ? context.colors.primary
                      : context.colors.divider,
                ),
                onPressed: () => _setCount(preset),
              ),
            if (widget.count != null)
              ActionChip(
                avatar: Icon(
                  Icons.clear_rounded,
                  size: context.dimens.iconSm,
                  color: context.colors.textSecondary,
                ),
                label: const Text('Clear'),
                labelStyle: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
                backgroundColor: context.colors.surface,
                side: BorderSide(color: context.colors.divider),
                onPressed: () => widget.onChanged(null),
              ),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Material(
      color: isEnabled
          ? context.colors.primary.withValues(alpha: 0.12)
          : context.colors.divider.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(context.dimens.sm),
          child: Icon(
            icon,
            size: context.dimens.iconMd,
            color: isEnabled
                ? context.colors.primary
                : context.colors.textSecondary.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
