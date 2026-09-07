import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class LoadingGate extends StatelessWidget {
  const LoadingGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: context.dimens.md),
          Text(
            context.l10n.testLoadingMessage,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
