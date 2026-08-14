import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/test_timer_viewmodel.dart';

/// Watches only [testTimerViewModelProvider], which ticks every second —
/// isolating the per-second rebuild to this small widget so the rest of the
/// test screen (question content, options) never re-renders on the tick.
class CountdownTimerBar extends ConsumerWidget {
  const CountdownTimerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secondsRemaining = ref.watch(testTimerViewModelProvider);
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    final isLow = secondsRemaining <= 60;

    return Text(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: isLow ? context.colors.error : context.colors.textPrimary,
      ),
    );
  }
}
