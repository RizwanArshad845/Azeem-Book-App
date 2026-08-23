import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_dropdown.dart';

/// A rounded card wrapper around [AppDropdown] with a leading icon and a
/// labelled header (with an optional red required asterisk). Standard style for
/// every dropdown field (campus, class, subject, filters) so they read the same
/// everywhere. The inner [AppDropdown] hides its own label; this card owns it.
class AppDropdownCard<T> extends StatelessWidget {
  const AppDropdownCard({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.itemAsString,
    this.compareFn,
    this.icon = Icons.tune_rounded,
    this.isRequired = false,
  });

  final String label;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? selectedItem;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final IconData icon;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.md,
        vertical: context.dimens.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.dimens.radiusLg),
        border: Border.all(color: context.colors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.dimens.sm),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            ),
            child: Icon(icon, color: context.colors.primary, size: context.dimens.iconMd),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Label(label: label, isRequired: isRequired),
                AppDropdown<T>(
                  label: label,
                  items: items,
                  onChanged: onChanged,
                  selectedItem: selectedItem,
                  itemAsString: itemAsString,
                  compareFn: compareFn,
                  hideLabel: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.isRequired});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.labelMedium?.copyWith(
      color: context.colors.textSecondary,
      fontWeight: FontWeight.w600,
    );
    if (!isRequired) return Text(label, style: style);
    return RichText(
      text: TextSpan(
        text: label,
        style: style,
        children: [
          TextSpan(
            text: ' *',
            style: style?.copyWith(color: context.colors.error, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
