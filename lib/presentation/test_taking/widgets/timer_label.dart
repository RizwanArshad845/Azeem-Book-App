import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/test_taking_viewmodel.dart';

class TimerLabel extends ConsumerWidget {
  const TimerLabel({super.key, required this.testId});

  final String testId;

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    return '$mStr:$sStr';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secondsRemaining = ref.watch(
      testTakingViewModelProvider(testId).select((async) {
        return async.value?.secondsRemaining;
      }),
    );
    if (secondsRemaining == null) return const SizedBox.shrink();

    final isLow = secondsRemaining <= 60;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.timer_outlined,
          size: context.dimens.iconSm,
          color: isLow ? context.colors.error : context.colors.textSecondary,
        ),
        SizedBox(width: context.dimens.xs),
        Text(
          _formatTimer(secondsRemaining),
          style: context.textStyles.titleSmall?.copyWith(
            color: isLow ? context.colors.error : context.colors.textPrimary,
            fontWeight: isLow ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
