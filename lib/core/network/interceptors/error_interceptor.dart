import 'package:dio/dio.dart';

import '../../../domain/common/failure.dart';
import '../session/session_expiry_notifier.dart';
import 'auth_interceptor.dart';

/// Maps every [DioException] to the app's [Failure] hierarchy (§8) and
/// attaches it as `err.error`, so repositories never need to interpret raw
/// Dio/HTTP details themselves.
///
/// Also treats every `401` as a signal to log out: the backend doesn't
/// distinguish an expired/invalid token from the "signed in on another
/// device" case by error code (both are just HTTP 401), so any 401 clears
/// the session — the router's redirect then takes the user back to login.
/// Fired via [SessionExpiryNotifier] rather than reaching into Riverpod
/// directly, so this core/network file has no dependency on presentation.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && _belongsToCurrentSession(err)) {
      SessionExpiryNotifier.onUnauthorized?.call();
    }
    handler.next(err.copyWith(error: _mapToFailure(err)));
  }

  /// Guards against a stale, slow-to-fail request logging out a session that
  /// was never involved: only treat a `401` as "the current session expired"
  /// if the request that failed was actually carrying the still-current
  /// token (skips both the "already logged out" and "logged back in with a
  /// new token since this request was sent" cases).
  bool _belongsToCurrentSession(DioException err) {
    final currentToken = AuthInterceptor.currentToken;
    if (currentToken == null) return false;
    final requestAuthHeader = err.requestOptions.headers['Authorization'];
    return requestAuthHeader == 'Bearer $currentToken';
  }

  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      default:
        break;
    }

    final statusCode = err.response?.statusCode;
    final serverMessage = _serverMessage(err);
    if (statusCode == 400) {
      return ValidationFailure(
        serverMessage ??
            'The information provided is incorrect or incomplete. Please check and try again.',
      );
    }
    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedFailure(serverMessage);
    }
    if (statusCode == 404) return NotFoundFailure(serverMessage);
    if (statusCode == 429) {
      return ValidationFailure(
        serverMessage ??
            'Too many attempts. Please wait a moment before trying again.',
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return ServerFailure(serverMessage);
    }
    return UnknownFailure(serverMessage ?? err.message);
  }

  /// The real backend always errors as `{"error": {"code", "message"}}`
  /// (`FRONTEND_INTEGRATION.md` §4) — surface that `message` instead of a
  /// generic one whenever the response body actually has this shape.
  String? _serverMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) return message;
      }
    }
    return null;
  }
}
