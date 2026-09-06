import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A cached payload plus the time it was written, used to answer
/// [LocalCacheService.isStale] without every caller re-parsing raw JSON.
class _CacheEnvelope {
  const _CacheEnvelope({required this.timestampMs, required this.data});

  final int timestampMs;
  final dynamic data;

  DateTime get storedAt => DateTime.fromMillisecondsSinceEpoch(timestampMs);

  Map<String, dynamic> toJson() => {'ts': timestampMs, 'data': data};

  static _CacheEnvelope? tryParse(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic> &&
          decoded['ts'] is int &&
          decoded.containsKey('data')) {
        return _CacheEnvelope(
          timestampMs: decoded['ts'] as int,
          data: decoded['data'],
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

/// Lightweight persistent cache service implementing Stale-While-Revalidate (SWR).
///
/// Stores JSON payloads with optional TTL timestamps to allow:
/// 1. Instant 0ms cache hits on app launch.
/// 2. Background revalidation checks.
class LocalCacheService {
  LocalCacheService({this.prefs});

  SharedPreferences? prefs;
  final Map<String, String> _memoryFallback = {};

  Future<void> init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  _CacheEnvelope? _read(String key) {
    final raw = prefs?.getString(key) ?? _memoryFallback[key];
    if (raw == null) return null;
    return _CacheEnvelope.tryParse(raw);
  }

  /// Returns cached object or null if not found.
  T? get<T>(String key, T Function(Map<String, dynamic> json) fromJson) {
    final entry = _read(key);
    if (entry == null) return null;
    try {
      return fromJson(entry.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Returns cached list or null if not found.
  List<T>? getList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final entry = _read(key);
    if (entry == null) return null;
    try {
      final data = entry.data;
      if (data is List) {
        return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Persists data to cache with current timestamp.
  Future<void> set(String key, dynamic data) async {
    final envelope = _CacheEnvelope(
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      data: data,
    );
    final payload = jsonEncode(envelope.toJson());
    _memoryFallback[key] = payload;
    await prefs?.setString(key, payload);
  }

  /// Checks if cached item exceeds [ttl].
  bool isStale(String key, {Duration ttl = const Duration(hours: 4)}) {
    final entry = _read(key);
    if (entry == null) return true;
    return DateTime.now().difference(entry.storedAt) > ttl;
  }

  /// Removes a cached key.
  Future<void> remove(String key) async {
    _memoryFallback.remove(key);
    await prefs?.remove(key);
  }

  /// Clears all cached items.
  Future<void> clear() async {
    _memoryFallback.clear();
    await prefs?.clear();
  }
}
