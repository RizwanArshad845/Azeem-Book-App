import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Shown while polling for the server's AI-graded result, between
/// [TestTakingStatus.submitting] and [TestTakingStatus.submitted].
class GradingInProgressView extends StatelessWidget {
  const GradingInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: context.dimens.md),
          Text(
            context.l10n.testGradingInProgressMessage,
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
