import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable top drag handle pill for modal bottom sheets or sliding panels.
class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.dimens.sm),
      child: Center(
        child: Container(
          width: context.dimens.dragHandleWidth,
          height: context.dimens.dragHandleHeight,
          decoration: BoxDecoration(
            color: context.colors.divider,
            borderRadius: BorderRadius.circular(context.dimens.pillRadius),
          ),
        ),
      ),
    );
  }
}
