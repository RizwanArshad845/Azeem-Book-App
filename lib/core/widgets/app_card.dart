import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'press_scale.dart';

/// Shared scannable-data container per §10.1 — cards for lists, never tables.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.0);
    final card = Container(
      padding: padding ?? EdgeInsets.all(context.dimens.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: radius,
        border: Border.all(color: context.colors.divider),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return PressScale(
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(borderRadius: radius, onTap: onTap, child: card),
      ),
    );
  }
}
