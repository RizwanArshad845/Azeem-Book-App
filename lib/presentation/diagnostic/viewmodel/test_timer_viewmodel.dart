import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import 'test_viewmodel.dart';

/// Kept as its own `Notifier<int>` (separate from [TestViewModel]) so that
/// only the small widget watching this provider rebuilds every second — the
/// rest of the test screen watches [testViewModelProvider] and is untouched
/// by the tick.
class TestTimerViewModel extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return AppConfig.testDurationMinutes * 60;
  }

  void start() {
    _timer?.cancel();
    state = AppConfig.testDurationMinutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state <= 1) {
        state = 0;
        _timer?.cancel();
        ref.read(testViewModelProvider.notifier).submit();
      } else {
        state -= 1;
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}

final testTimerViewModelProvider =
    NotifierProvider<TestTimerViewModel, int>(TestTimerViewModel.new);
