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

/// Firebase Cloud Messaging glue: sends this install's FCM registration token
/// to the backend (`PUT /push/device`) once there is a signed-up account,
/// removes it on logout, and shows pushes that arrive while the app is open
/// (Android doesn't display those by itself).
///
/// Uses the registration-token API (getToken/onTokenRefresh/deleteToken) on
/// purpose although firebase_messaging 17 marks it deprecated: its
/// replacement (register() + the onRegistered callback) never delivered an id
/// on a real Android phone, so no device ever got registered. getToken()
/// returns the token directly — nothing to miss.
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
      // FCM occasionally rotates the token; keep the backend's copy current.
      // ignore: deprecated_member_use
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        if (_shouldBeRegistered) unawaited(_sendToken(token));
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
      // ignore: deprecated_member_use
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        _logger.w('Push: FCM returned no token');
        return;
      }
      await _sendToken(token);
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
      // A fresh token for whoever signs in next on this phone.
      // ignore: deprecated_member_use
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
    _unregistering = false;
  }

  Future<void> _sendToken(String token) async {
    try {
      await _dio.put<void>(
        ApiEndpoints.pushDevice,
        data: {
          'token': token,
          'platform': defaultTargetPlatform == TargetPlatform.iOS
              ? 'ios'
              : 'android',
        },
      );
      _logger.i('Push: device registered');
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
