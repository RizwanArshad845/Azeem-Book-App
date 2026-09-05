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
    // Full body only for the attempt submit/poll cycle — narrow on purpose so
    // this never dumps OTP/auth/profile payloads (phone numbers, tokens) to
    // device logs for every other endpoint.
    if (response.requestOptions.path.contains('/attempts/')) {
      _logger.d('    body: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('<-- ERROR ${err.requestOptions.uri}', err);
    handler.next(err);
  }
}
