import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.itemAsString,
    this.compareFn,
    this.hideLabel = false,
    this.dropdownBuilder,
    this.itemBuilder,
    this.popupConstraints,
  });

  final String label;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? selectedItem;
  final String Function(T)? itemAsString;

  /// When true the floating [label] is dropped (used as hint instead) so a
  /// parent like [AppDropdownCard] can own the labelled header.
  final bool hideLabel;

  /// `dropdown_search` requires this for any `T` that isn't `String`/`int`/
  /// `double` (it can't otherwise tell which item is "selected"). Defaults
  /// to `==`, which is correct for any `T` with value equality (e.g. every
  /// `freezed` entity in this app) — override only for a `T` without one.
  final bool Function(T, T)? compareFn;

  final Widget Function(BuildContext context, T? selectedItem)? dropdownBuilder;
  final Widget Function(
    BuildContext context,
    T item,
    bool isDisabled,
    bool isSelected,
  )?
  itemBuilder;
  final BoxConstraints? popupConstraints;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // dropdown_search's popup menu only inherits the anchor field's measured
    // width implicitly (via its own RenderBox) when no min/maxWidth is
    // given — unreliable for our custom card-style `dropdownBuilder`s, which
    // can size to intrinsic content rather than the available width. Pin the
    // popup's width explicitly to the field's actual layout width instead.
    //
    // Note: dropdown_search's `MenuAlign.bottomStart`/`bottomEnd` are NOT
    // RTL-aware (always literal left/right, regardless of Directionality) —
    // harmless here since a full-width popup positions identically either
    // way; the field's own text/search-box alignment (below) is what
    // actually mirrors for RTL.
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedWidth = constraints.hasBoundedWidth;
        final fieldWidth = hasBoundedWidth ? constraints.maxWidth : null;

        return DropdownSearch<T>(
          items: (filter, infiniteScrollProps) => items,
          selectedItem: selectedItem,
          itemAsString: itemAsString,
          compareFn: compareFn ?? (a, b) => a == b,
          onSelected: onChanged,
          dropdownBuilder: dropdownBuilder,
          suffixProps: const DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(isVisible: false),
          ),
          decoratorProps: DropDownDecoratorProps(
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            baseStyle: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: hideLabel
                ? InputDecoration(
                    hintText: label,
                    hintStyle: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.textSecondary.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  )
                : InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        context.dimens.radiusMd,
                      ),
                    ),
                  ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: items.length > 5,
            constraints: BoxConstraints(
              minWidth: fieldWidth ?? 0.0,
              maxWidth: fieldWidth ?? double.infinity,
              maxHeight: popupConstraints?.maxHeight ?? 300,
            ),
            menuProps: MenuProps(
              align: MenuAlign.bottomStart,
              backgroundColor: context.colors.surface,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dimens.radiusMd),
              ),
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.black.withValues(alpha: 0.25),
            ),
            searchFieldProps: TextFieldProps(
              autofocus: false,
              textDirection: Directionality.of(context),
              decoration: InputDecoration(
                hintText: context.l10n.commonSearch,
                hintStyle: TextStyle(color: context.colors.textSecondary),
                prefixIcon: Icon(
                  Icons.search,
                  size: context.dimens.iconMd,
                  color: context.colors.textSecondary,
                ),
                isDense: true,
                filled: true,
                fillColor: context.colors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.dimens.md,
                  vertical: context.dimens.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                  borderSide: BorderSide(color: context.colors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                  borderSide: BorderSide(color: context.colors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                  borderSide: BorderSide(
                    color: context.colors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            itemBuilder:
                itemBuilder ??
                (context, item, isDisabled, isSelected) {
                  final text = itemAsString != null
                      ? itemAsString!(item)
                      : item.toString();
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.dimens.md,
                      vertical: context.dimens.sm + 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: context.colors.divider.withValues(alpha: 0.4),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            text,
                            style: context.textStyles.bodyMedium?.copyWith(
                              color: isSelected
                                  ? context.colors.primary
                                  : (isDisabled
                                        ? context.colors.textSecondary
                                              .withValues(alpha: 0.5)
                                        : context.colors.textPrimary),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: context.dimens.sm),
                          Icon(
                            Icons.check_circle_rounded,
                            size: context.dimens.iconSm + 2,
                            color: context.colors.primary,
                          ),
                        ],
                      ],
                    ),
                  );
                },
          ),
        );
      },
    );
  }
}
