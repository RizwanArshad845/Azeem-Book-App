import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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
      ).timeout(const Duration(seconds: 4));
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  };
});

/// `true` while the device is really online, `false` as soon as it isn't.
/// Starts `true` so the app never flashes the offline screen while the first
/// check is still running.
///
/// Two signals are combined:
/// - `connectivity_plus` change events, so losing every network flips this to
///   offline immediately (no waiting on a lookup);
/// - a real reachability check (see [internetReachabilityProvider]) on every
///   change, on [recheck], and every [_pollInterval], because an interface
///   being "up" doesn't mean the internet works (captive/no-uplink Wi-Fi).
class ConnectivityNotifier extends Notifier<bool> {
  static const _pollInterval = Duration(seconds: 5);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _timer;
  bool _checking = false;
  bool _recheckQueued = false;

  @override
  bool build() {
    final connectivity = ref.read(connectivityServiceProvider);
    _subscription = connectivity.onConnectivityChanged.listen(
      _onInterfaceChange,
      onError: (Object e, StackTrace st) =>
          sl<Logger>().e('Connectivity stream error', e, st),
    );
    _timer = Timer.periodic(_pollInterval, (_) => _refresh());
    ref.onDispose(() {
      _subscription?.cancel();
      _timer?.cancel();
    });
    _refresh();
    return true;
  }

  void _onInterfaceChange(List<ConnectivityResult> results) {
    if (!_hasInterface(results)) {
      _set(false); // lost every network: show the offline screen right now
      return;
    }
    _refresh();
  }

  bool _hasInterface(List<ConnectivityResult> results) =>
      results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);

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
        var hasInterface = true;
        try {
          hasInterface = _hasInterface(
            await ref.read(connectivityServiceProvider).checkConnectivity(),
          );
        } catch (e, st) {
          // e.g. the native plugin isn't registered (app not fully rebuilt
          // after adding it) — log it and fall back to reachability alone.
          sl<Logger>().e('connectivity_plus checkConnectivity failed', e, st);
        }
        final online =
            hasInterface && await ref.read(internetReachabilityProvider)();
        _set(online);
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
