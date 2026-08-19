import 'package:dio/dio.dart';

import '../../../domain/common/failure.dart';

/// Maps every [DioException] to the app's [Failure] hierarchy (§8) and
/// attaches it as `err.error`, so repositories never need to interpret raw
/// Dio/HTTP details themselves.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: _mapToFailure(err)));
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
