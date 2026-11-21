import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import '../network/api_endpoints.dart';
import 'logger.dart';

/// What the backend puts in every push's data payload
/// (`apps/notifications/tasks.py`).
class PushPayload {
  const PushPayload({this.notificationId, this.type, this.recipientRole});

  factory PushPayload.fromData(Map<String, dynamic> data) => PushPayload(
    notificationId: data['notificationId'] as String?,
    type: data['type'] as String?,
    recipientRole: data['recipientRole'] as String?,
  );

  final String? notificationId;
  final String? type;
  final String? recipientRole;
}

/// Firebase Cloud Messaging glue: registers this install with FCM and sends
/// its Firebase Installation ID (FID — FCM's send target) to the backend
/// (`PUT /push/device`) once there is a signed-up account, unregisters on
/// logout, and shows pushes that arrive while the app is open (Android doesn't
/// display those by itself).
///
/// Everything here is best-effort: push failing must never block login,
/// logout or app start — notifications are still in the in-app list.
class PushNotificationService {
  PushNotificationService(this._dio, this._logger);

  final Dio _dio;
  final Logger _logger;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  /// Must match `ANDROID_CHANNEL_ID` in the backend's `apps/notifications/push.py`.
  static const _channel = AndroidNotificationChannel(
    'azeem_default',
    'Notifications',
    description: 'Approvals, results, payments and other account updates',
    importance: Importance.high,
  );

  bool _available = false;
  bool _shouldBeRegistered = false;
  bool _unregistering = false;
  String? _fid;

  /// Sets up Firebase and the listeners. [onMessage] runs for every push that
  /// arrives while the app is open; [onTap] when the user taps one (system
  /// tray while backgrounded, or the one we showed in the foreground).
  Future<void> init({
    required void Function(PushPayload payload) onMessage,
    required void Function(PushPayload payload) onTap,
  }) async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options == null) return; // Platform not configured in Firebase yet.
    try {
      await Firebase.initializeApp(options: options);

      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (response) {
          final raw = response.payload;
          if (raw == null) return;
          onTap(PushPayload.fromData(jsonDecode(raw) as Map<String, dynamic>));
        },
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      FirebaseMessaging.onMessage.listen((message) {
        unawaited(_showForeground(message));
        onMessage(PushPayload.fromData(message.data));
      });
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => onTap(PushPayload.fromData(message.data)),
      );
      // Fires after register() completes, and again if FCM reassigns the id.
      FirebaseMessaging.instance.onRegistered.listen((fid) {
        _fid = fid;
        if (_shouldBeRegistered) unawaited(_sendFid(fid));
      });
      _available = true;
    } catch (e, st) {
      _logger.e('Push notifications unavailable', e, st);
    }
  }

  /// Asks for notification permission (Android 13+ / iOS) and registers this
  /// device for the signed-in account. Call once the account exists (i.e.
  /// after signup) — the backend 404s before that.
  Future<void> registerDevice() async {
    _shouldBeRegistered = true;
    if (!_available) return;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      // Already registered in this run (e.g. signup right after login): the
      // id is known, send it now. Otherwise onRegistered sends it.
      final fid = _fid;
      if (fid != null) await _sendFid(fid);
      await FirebaseMessaging.instance.register();
    } catch (e, st) {
      _logger.e('Push device registration failed', e, st);
    }
  }

  /// Stops pushes to this device. Call BEFORE the session token is cleared —
  /// the request needs it. Bounded so an offline logout doesn't hang.
  Future<void> unregisterDevice() async {
    _shouldBeRegistered = false;
    // Logout triggered by a 401 from this very request must not recurse.
    if (!_available || _unregistering) return;
    _unregistering = true;
    try {
      await _dio
          .delete<void>(ApiEndpoints.pushDevice)
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // Offline or session already gone — the backend also drops the old
      // device on the next login, so nothing is lost.
    }
    try {
      // A fresh id for whoever signs in next on this phone.
      await FirebaseMessaging.instance.unregister();
      _fid = null;
    } catch (_) {}
    _unregistering = false;
  }

  Future<void> _sendFid(String fid) async {
    try {
      await _dio.put<void>(
        ApiEndpoints.pushDevice,
        data: {
          'token': fid,
          'platform': defaultTargetPlatform == TargetPlatform.iOS
              ? 'ios'
              : 'android',
        },
      );
    } catch (e) {
      _logger.w('Push device upload failed: $e');
    }
  }

  Future<void> _showForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;
    await _localNotifications.show(
      id: message.messageId.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
