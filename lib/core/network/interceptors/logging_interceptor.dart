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
    _logger.d('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d('<-- ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('<-- ERROR ${err.requestOptions.uri}', err);
    handler.next(err);
  }
}
