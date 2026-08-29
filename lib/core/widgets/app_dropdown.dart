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
  });

  final String label;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? selectedItem;
  final String Function(T)? itemAsString;

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
        decoration: InputDecoration(labelText: label),
      ),
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        showSearchBox: items.length > 6,
        constraints: BoxConstraints(
          maxHeight: (items.length * 52.0 + (items.length > 6 ? 64.0 : 8.0))
              .clamp(56.0, 260.0),
        ),
        menuProps: MenuProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.dimens.radiusMd),
          ),
          elevation: 6,
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: context.l10n.commonSearch,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimens.radiusMd),
            ),
          ),
        ),
      ),
    );
  }
}
