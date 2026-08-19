import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable action bar for modal dialogs featuring top divider and aligned action buttons.
class DialogActions extends StatelessWidget {
  const DialogActions({
    super.key,
    required this.actions,
  });

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(height: 1, color: context.colors.divider),
        Padding(
          padding: EdgeInsets.all(context.dimens.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        ),
      ],
    );
  }
}
