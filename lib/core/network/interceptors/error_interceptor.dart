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
    if (statusCode == 401) return const UnauthorizedFailure();
    if (statusCode == 404) return const NotFoundFailure();
    if (statusCode != null && statusCode >= 500) return const ServerFailure();
    return UnknownFailure(err.message);
  }
}
