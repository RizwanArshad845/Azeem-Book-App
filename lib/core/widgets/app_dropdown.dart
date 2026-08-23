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

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: (filter, infiniteScrollProps) => items,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      compareFn: compareFn ?? (a, b) => a == b,
      onSelected: onChanged,
      decoratorProps: DropDownDecoratorProps(
        decoration: hideLabel
            ? InputDecoration(
                hintText: label,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              )
            : InputDecoration(labelText: label),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: items.length > 5,
        constraints: const BoxConstraints(maxHeight: 320),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            ),
          ),
        ),
      ),
    );
  }
}
