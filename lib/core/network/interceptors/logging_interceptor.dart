import 'package:dio/dio.dart';

import '../../services/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor([Logger? logger]) : _logger = logger ?? ConsoleLogger();

  final Logger _logger;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _logger.d('--> ${options.method} ${options.uri} @ ${DateTime.now()}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d(
      '<-- ${response.statusCode} ${response.requestOptions.uri} @ ${DateTime.now()}',
    );
    // Log full body for attempt, cart, and payment endpoints to aid checkout
    // debugging without exposing auth/profile payloads (phone numbers, tokens).
    final path = response.requestOptions.path;
    if (path.contains('/attempts/') ||
        path.contains('/cart') ||
        path.contains('checkout') ||
        path.contains('/payments/')) {
      _logger.d('    body: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '<-- ERROR ${err.requestOptions.method} ${err.requestOptions.uri} '
      'status=${err.response?.statusCode} body=${err.response?.data}',
      err,
    );
    handler.next(err);
  }
}
