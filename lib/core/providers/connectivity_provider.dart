import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../di/injection.dart';
import '../services/logger.dart';

/// Injectable so tests can swap in a fake instead of the platform plugin.
final connectivityServiceProvider = Provider<Connectivity>(
  (ref) => Connectivity(),
);

/// Whether the backend host can actually be reached right now. A DNS lookup
/// is enough: it fails with no connection (including "Wi-Fi connected but no
/// internet"), and succeeds over mobile data when Wi-Fi is off. Injectable
/// for tests.
final internetReachabilityProvider = Provider<Future<bool> Function()>((ref) {
  final host = Uri.parse(AppConfig.apiBaseUrl).host;
  return () async {
    try {
      final addresses = await InternetAddress.lookup(
        host,
      ).timeout(const Duration(seconds: 5));
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    } catch (_) {
      // SocketException, TimeoutException, or any platform lookup error.
      return false;
    }
  };
});

/// `true` while the device is really online, `false` as soon as it isn't.
/// Starts `true` so the app never flashes the offline screen while the first
/// check is still running.
///
/// Two signals are combined:
/// - `connectivity_plus` interface state, so losing every network flips this
///   to offline right away (once re-confirmed — Android emits a transient
///   `none` during Wi-Fi ↔ mobile handover);
/// - a real reachability check (see [internetReachabilityProvider]) on every
///   change, on [recheck], and every [_pollInterval], because an interface
///   being "up" doesn't mean the internet works (captive/no-uplink Wi-Fi).
///   A single failed lookup is treated as a blip: it takes
///   [_failureThreshold] consecutive failures to go offline.
///
/// Polling pauses while the app is backgrounded — the OS restricts network
/// access then, so lookups fail and would wrongly show the offline screen on
/// resume.
class ConnectivityNotifier extends Notifier<bool> {
  static const _pollInterval = Duration(seconds: 5);
  static const _confirmDelay = Duration(seconds: 2);
  static const _failureThreshold = 2;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  AppLifecycleListener? _lifecycle;
  Timer? _timer;
  Timer? _confirmTimer;
  bool _checking = false;
  bool _recheckQueued = false;
  int _failures = 0;

  @override
  bool build() {
    final connectivity = ref.read(connectivityServiceProvider);
    _subscription = connectivity.onConnectivityChanged.listen(
      _onInterfaceChange,
      onError: (Object e, StackTrace st) =>
          sl<Logger>().e('Connectivity stream error', e, st),
    );
    _lifecycle = AppLifecycleListener(
      onResume: _onResume,
      onHide: _stopPolling,
    );
    _startPolling();
    ref.onDispose(() {
      _subscription?.cancel();
      _lifecycle?.dispose();
      _stopPolling();
    });
    _refresh();
    return true;
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(_pollInterval, (_) => _refresh());
  }

  void _stopPolling() {
    _timer?.cancel();
    _confirmTimer?.cancel();
  }

  void _onResume() {
    _failures = 0; // background failures don't count
    _startPolling();
    _refresh();
  }

  Future<void> _onInterfaceChange(List<ConnectivityResult> results) async {
    if (!_hasInterface(results) && !await _currentlyHasInterface()) {
      _failures = _failureThreshold;
      _set(false); // lost every network: show the offline screen right now
      return;
    }
    _refresh();
  }

  bool _hasInterface(List<ConnectivityResult> results) =>
      results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);

  Future<bool> _currentlyHasInterface() async {
    try {
      return _hasInterface(
        await ref.read(connectivityServiceProvider).checkConnectivity(),
      );
    } catch (e, st) {
      // e.g. the native plugin isn't registered (app not fully rebuilt
      // after adding it) — log it and fall back to reachability alone.
      sl<Logger>().e('connectivity_plus checkConnectivity failed', e, st);
      return true;
    }
  }

  /// Re-checks both signals (the offline screen's "Try again").
  Future<void> recheck() => _refresh();

  Future<void> _refresh() async {
    if (_checking) {
      _recheckQueued = true; // run once more after the current check
      return;
    }
    _checking = true;
    try {
      do {
        _recheckQueued = false;
        if (!await _currentlyHasInterface()) {
          _failures = _failureThreshold;
          _set(false);
        } else if (await ref.read(internetReachabilityProvider)()) {
          _failures = 0;
          _set(true);
        } else if (++_failures >= _failureThreshold) {
          _set(false);
        } else {
          // First failure: confirm soon instead of waiting a full poll.
          _confirmTimer?.cancel();
          _confirmTimer = Timer(_confirmDelay, _refresh);
        }
      } while (_recheckQueued && ref.mounted);
    } finally {
      _checking = false;
    }
  }

  void _set(bool online) {
    if (!ref.mounted) return;
    state = online;
  }
}

final isOnlineProvider = NotifierProvider<ConnectivityNotifier, bool>(
  ConnectivityNotifier.new,
);
