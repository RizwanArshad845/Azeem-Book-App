import 'dart:async';

/// Caps how many async tasks can be "in flight" at once. Callers `acquire()`
/// before starting work and `release()` when it finishes; once [maxConcurrent]
/// slots are taken, further callers queue (FIFO) until one is released.
class ConcurrencyGate {
  ConcurrencyGate(this.maxConcurrent);

  final int maxConcurrent;
  int _active = 0;
  final _waiters = <Completer<void>>[];

  Future<void> acquire() {
    if (_active < maxConcurrent) {
      _active++;
      return Future.value();
    }
    final completer = Completer<void>();
    _waiters.add(completer);
    return completer.future;
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeAt(0).complete();
    } else {
      _active = (_active - 1).clamp(0, maxConcurrent);
    }
  }
}
