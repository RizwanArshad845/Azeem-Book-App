import 'package:dio/dio.dart';

/// Attaches the current session token (if any) to every outgoing request.
/// Set by the auth feature once a session exists; read here so the network
/// layer has no compile-time dependency on the auth feature.
class AuthInterceptor extends Interceptor {
  static String? currentToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = currentToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
