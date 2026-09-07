import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/class_level.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';

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
    // Catalog endpoints (campuses/classLevels/boardClasses/subjects) require
    // auth on the backend. Without a session yet, every one of these
    // requests would 401 — and since they're plain (non-`.autoDispose`)
    // `FutureProvider`s cached for the whole app-session lifetime, a
    // pre-login 401 would permanently poison that cache entry (e.g. a
    // specific board class's subjects) until something manually
    // invalidates it. Defer the whole preload until a session exists
    // instead of racing/guaranteeing a doomed first attempt.
    if (ref.read(currentUserProvider) == null) return;

    final timeoutCompleter = Completer<void>();
    _timeoutTimer = Timer(const Duration(seconds: 4), () {
      if (!timeoutCompleter.isCompleted) {
        timeoutCompleter.complete();
      }
    });

    try {
      await Future.any<dynamic>([
        Future.wait<dynamic>([
          ref.read(campusesProvider.future).catchError((_) => <Campus>[]),
          ref.read(classLevelsProvider.future).catchError((_) => <ClassLevel>[]),
          ref.read(boardClassesProvider.future).then((boardClasses) async {
            await Future.wait(
              boardClasses
                  .where((b) => b.isEnabled)
                  .map((b) => ref
                      .read(subjectsForBoardClassProvider(b.id).future)
                      .catchError((_) => <Subject>[])),
            );
          }).catchError((_) => null),
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

