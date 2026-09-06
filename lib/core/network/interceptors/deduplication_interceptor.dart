import 'dart:async';
import 'package:dio/dio.dart';

/// Interceptor that deduplicates concurrent in-flight GET requests.
///
/// If multiple widgets, use cases, or providers trigger the same GET request
/// while one is already pending, subsequent requests attach to the existing
/// in-flight [Future] rather than executing duplicate network round-trips.
class DeduplicationInterceptor extends Interceptor {
  final Map<String, Completer<Response<dynamic>>> _inFlightRequests = {};

  String _generateKey(RequestOptions options) {
    return '${options.method}:${options.baseUrl}${options.path}:${options.queryParameters.toString()}';
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only deduplicate idempotent read requests (GET/HEAD)
    if (options.method.toUpperCase() != 'GET' &&
        options.method.toUpperCase() != 'HEAD') {
      return handler.next(options);
    }

    final key = _generateKey(options);

    // If there is already an active identical request in flight
    if (_inFlightRequests.containsKey(key)) {
      try {
        final response = await _inFlightRequests[key]!.future;
        // Return a clone of the response for the duplicate caller
        return handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            data: response.data,
            headers: response.headers,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            extra: response.extra,
          ),
        );
      } catch (err) {
        if (err is DioException) {
          return handler.reject(err);
        }
        return handler.reject(
          DioException(
            requestOptions: options,
            error: err,
          ),
        );
      }
    }

    // Register this request as in-flight
    _inFlightRequests[key] = Completer<Response<dynamic>>();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final key = _generateKey(response.requestOptions);
    final completer = _inFlightRequests.remove(key);
    completer?.complete(response);
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final key = _generateKey(err.requestOptions);
    final completer = _inFlightRequests.remove(key);
    completer?.completeError(err);
    handler.next(err);
  }
}
