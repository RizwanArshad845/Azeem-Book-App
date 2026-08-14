import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';

class SplashViewModel extends Notifier<bool> {
  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    _timer = Timer(const Duration(seconds: AppConfig.splashDelaySeconds), () {
      state = true;
    });
    return false;
  }
}

final splashViewModelProvider =
    NotifierProvider<SplashViewModel, bool>(SplashViewModel.new);
