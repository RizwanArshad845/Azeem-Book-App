import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import 'grading_progress_ring.dart';

/// Shown while polling for the server's AI-graded result, between
/// [TestTakingStatus.submitting] and [TestTakingStatus.submitted].
class GradingInProgressView extends StatelessWidget {
  const GradingInProgressView({super.key, required this.progress});

  /// 0.0-1.0 eased fake-progress — see `TestTakingViewModel._pollUntilGraded`.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GradingProgressRing(progress: progress),
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
