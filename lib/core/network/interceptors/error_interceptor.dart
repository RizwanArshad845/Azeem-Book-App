import 'package:dio/dio.dart';

import '../../../domain/common/failure.dart';
import '../../di/injection.dart';
import '../../services/logger.dart';
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
    final statusCode = err.response?.statusCode;
    final code = _errorCode(err);

    // `account_deleted` must be checked BEFORE the generic 401 handling
    // below: a 401 is no longer always "expired session" — here it means the
    // account was deleted, which gets its own dialog instead of a silent
    // logout. A 403 with this code (login/signup) has no session to clear.
    if (code == _accountDeleted) {
      if (statusCode == 403) {
        SessionExpiryNotifier.onAccountDeleted?.call(clearSession: false);
      } else if (statusCode == 401 && _belongsToCurrentSession(err)) {
        SessionExpiryNotifier.onAccountDeleted?.call(clearSession: true);
      }
    } else if (code == _teacherPendingApproval && statusCode == 403) {
      // Dashboard endpoints are gated until an admin approves the teacher.
      // Normally status-based routing keeps them away from here; this covers
      // a stale session (e.g. an admin moved them back to pending).
      SessionExpiryNotifier.onTeacherPendingApproval?.call();
    } else if (statusCode == 401 && _belongsToCurrentSession(err)) {
      SessionExpiryNotifier.onUnauthorized?.call();
    }
    handler.next(err.copyWith(error: _mapToFailure(err)));
  }

  static const _accountDeleted = 'account_deleted';
  static const _teacherPendingApproval = 'teacher_pending_approval';
  static const _phoneRegisteredOtherRole = 'phone_registered_other_role';
  static const _phoneAlreadyRegistered = 'phone_already_registered';

  /// The `error` object of the `{"error": {"code", "message", ...}}` envelope
  /// (extra fields like `contactEmail`/`existingRole` live next to `code`).
  Map<String, dynamic>? _errorBody(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) return error;
    }
    return null;
  }

  String? _errorCode(DioException err) {
    final code = _errorBody(err)?['code'];
    return code is String ? code : null;
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

    // Account-state codes — branch on `error.code`, never on message text.
    switch (_errorCode(err)) {
      case _accountDeleted when statusCode == 401 || statusCode == 403:
        final email = _errorBody(err)?['contactEmail'];
        return AccountDeletedFailure(email is String ? email : null);
      case _phoneRegisteredOtherRole when statusCode == 409:
        final role = _errorBody(err)?['existingRole'];
        if (role is String && role.isNotEmpty) {
          return PhoneRegisteredOtherRoleFailure(role);
        }
      case _phoneAlreadyRegistered when statusCode == 409:
        return const PhoneAlreadyRegisteredFailure();
    }

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
    if (serverMessage != null) return UnknownFailure(serverMessage);
    sl<Logger>().e(
      'Unmapped error status on ${err.requestOptions.method} '
      '${err.requestOptions.path}: type=${err.type}, status=$statusCode, '
      'message=${err.message}',
      err,
      err.stackTrace,
    );
    return const UnknownFailure();
  }

  /// The real backend always errors as `{"error": {"code", "message"}}`
  /// (`FRONTEND_INTEGRATION.md` §4) — surface that `message` instead of a
  /// generic one whenever the response body actually has this shape.
  ///
  /// One documented exception: invalid `subjectId` on add-to-cart returns a
  /// bare DRF field-error body, `{"subjectId": "Subject not found."}`
  /// (`MOBILE_CHANGES.md` §3), not wrapped in the `error` envelope above —
  /// special-cased narrowly rather than surfacing arbitrary field-error
  /// values so unrelated server internals never leak into the UI.
  String? _serverMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) return message;
      }
      final subjectIdError = data['subjectId'];
      if (subjectIdError is String && subjectIdError.isNotEmpty) {
        return subjectIdError;
      }
    }
    return null;
  }
}
