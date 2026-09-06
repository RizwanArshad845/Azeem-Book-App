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
    // The response body on an error (typically a DRF field-validation
    // object, e.g. `{"phone_number": ["This field is required."]}`) is the
    // single most useful piece of information for diagnosing a 400/422 —
    // without it, only DioException's generic status-code description was
    // ever visible in logs, which never says *which* field the backend
    // rejected or why.
    final body = err.response?.data;
    _logger.e(
      '<-- ERROR ${err.requestOptions.uri}${body != null ? ' | body: $body' : ''}',
      err,
    );
    handler.next(err);
  }
}
