import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'bottom_sheet_drag_handle.dart';
import 'bottom_sheet_header.dart';

/// Reusable modal bottom sheet component following the design system.
/// Supports keyboard avoidance, max width boundaries, drag handles, and header titles.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showCloseButton = true,
    this.showDragHandle = true,
    this.padding,
    this.maxHeightFraction = 0.85,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showCloseButton;
  final bool showDragHandle;
  final EdgeInsetsGeometry? padding;
  final double maxHeightFraction;

  /// Utility method to display an [AppBottomSheet] modally.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    bool showCloseButton = true,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    EdgeInsetsGeometry? padding,
    double maxHeightFraction = 0.85,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => AppBottomSheet(
        title: title,
        subtitle: subtitle,
        showCloseButton: showCloseButton,
        showDragHandle: showDragHandle,
        padding: padding,
        maxHeightFraction: maxHeightFraction,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final maxSheetHeight = mediaQuery.size.height * maxHeightFraction;
    final screenWidth = mediaQuery.size.width;
    final maxWidth = context.dimens.contentMaxWidth;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxSheetHeight,
        maxWidth: maxWidth,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth > maxWidth ? (screenWidth - maxWidth) / 2 : 0,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimens.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: context.dimens.md,
            offset: Offset(0, -context.dimens.xs),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showDragHandle) const BottomSheetDragHandle(),
                if (title != null || showCloseButton)
                  BottomSheetHeader(
                    title: title,
                    subtitle: subtitle,
                    showCloseButton: showCloseButton,
                  ),
                Padding(
                  padding: padding ?? EdgeInsets.all(context.dimens.lg),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
