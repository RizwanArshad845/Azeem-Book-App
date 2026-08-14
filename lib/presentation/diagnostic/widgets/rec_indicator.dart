import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class RecIndicator extends StatelessWidget {
  const RecIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dimens.md),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
          SizedBox(width: context.dimens.xs),
          Text(
            context.l10n.testRecLabel,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
