import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/riverpod_providers.dart';

class SplashViewModel extends Notifier<bool> {
  Timer? _splashTimer;
  Timer? _timeoutTimer;
  bool _isDisposed = false;

  @override
  bool build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _splashTimer?.cancel();
      _timeoutTimer?.cancel();
    });
    _initialize();
    return false;
  }

  Future<void> _initialize() async {
    final timerCompleter = Completer<void>();
    _splashTimer = Timer(
      const Duration(seconds: AppConfig.splashDelaySeconds),
      () {
        if (!timerCompleter.isCompleted) {
          timerCompleter.complete();
        }
      },
    );

    // Preload independent network calls (campuses, class levels, board classes)
    // behind the initial logo screen so downstream onboarding feels instant with zero lag.
    final preloadFuture = _preloadIndependentData();

    await Future.wait<void>([timerCompleter.future, preloadFuture]);

    if (!_isDisposed) {
      state = true;
    }
  }

  Future<void> _preloadIndependentData() async {
    final timeoutCompleter = Completer<void>();
    _timeoutTimer = Timer(const Duration(seconds: 4), () {
      if (!timeoutCompleter.isCompleted) {
        timeoutCompleter.complete();
      }
    });

    try {
      await Future.any<dynamic>([
        Future.wait<dynamic>([
          ref.read(campusesProvider.future),
          ref.read(classLevelsProvider.future),
          ref.read(boardClassesProvider.future),
        ]),
        timeoutCompleter.future,
      ]);
    } catch (_) {
      // Graceful degradation: network failures or offline state never block
      // the user on the splash screen.
    } finally {
      _timeoutTimer?.cancel();
      if (!timeoutCompleter.isCompleted) {
        timeoutCompleter.complete();
      }
    }
  }
}

final splashViewModelProvider =
    NotifierProvider<SplashViewModel, bool>(SplashViewModel.new);

