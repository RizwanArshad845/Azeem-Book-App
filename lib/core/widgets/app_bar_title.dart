import 'package:flutter/material.dart';

/// Shared app bar title text — every `AppBar(title: ...)` in the app routes
/// through this so no title can ever produce a `RenderFlex`/pixel overflow,
/// regardless of string length, locale, or device width. Worst case is a
/// clean single-line ellipsis instead of clipped/overflowing pixels.
class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}
