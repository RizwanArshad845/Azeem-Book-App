import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/deduplication_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  const DioClient._();

  static Dio build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.addAll([
      DeduplicationInterceptor(),
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
    return dio;
  }
}
