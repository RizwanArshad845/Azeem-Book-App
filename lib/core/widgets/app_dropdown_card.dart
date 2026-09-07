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
    this.valueBuilder,
    this.itemBuilder,
    this.popupConstraints,
  });

  final String label;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? selectedItem;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final IconData icon;
  final bool isRequired;

  /// Overrides how the selected value is displayed inside the card (the
  /// card's own icon/label chrome is always drawn regardless) — falls back
  /// to a plain `Text` when omitted.
  final Widget Function(BuildContext context, T? selectedItem)? valueBuilder;
  final Widget Function(BuildContext context, T item, bool isDisabled, bool isSelected)? itemBuilder;
  final BoxConstraints? popupConstraints;

  @override
  Widget build(BuildContext context) {
    return AppDropdown<T>(
      label: label,
      items: items,
      onChanged: onChanged,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      compareFn: compareFn,
      hideLabel: true,
      itemBuilder: itemBuilder,
      popupConstraints: popupConstraints,
      dropdownBuilder: (context, selected) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimens.sm,
            vertical: context.dimens.sm - 2,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.dimens.radiusLg),
            border: Border.all(color: context.colors.divider),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: context.colors.primary,
                  size: context.dimens.iconSm + 2,
                ),
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Label(label: label, isRequired: isRequired),
                    const SizedBox(height: 2),
                    if (valueBuilder != null)
                      valueBuilder!(context, selected)
                    else
                      Text(
                        selected != null
                            ? (itemAsString != null
                                ? itemAsString!(selected)
                                : selected.toString())
                            : label,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: selected != null
                              ? context.colors.textPrimary
                              : context.colors.textSecondary
                                  .withValues(alpha: 0.7),
                          fontWeight: selected != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
    if (!isRequired) {
      return Text(
        label,
        style: style,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text.rich(
      TextSpan(
        text: label,
        style: style,
        children: [
          TextSpan(
            text: ' *',
            style: style?.copyWith(
              color: context.colors.error,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}
