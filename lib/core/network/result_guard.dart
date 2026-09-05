import 'package:dio/dio.dart';

import '../../domain/common/failure.dart';
import '../../domain/common/result.dart';
import '../di/injection.dart';
import '../services/logger.dart';

/// Runs [body] (a single Dio call, or a call + DTO mapping) and converts any
/// thrown exception into a [Result.failure] — the single place every
/// datasource should route through instead of hand-rolling its own
/// try/catch, so a backend/DTO contract mismatch is never silently
/// swallowed into a blank "Something went wrong." with no trace anywhere.
///
/// Always logs the raw exception (type, message, stack trace) before
/// wrapping it, specifically for the two cases that otherwise vanish
/// without a trace: an unrecognized [DioException] (not already mapped to a
/// [Failure] by `ErrorInterceptor`) and any non-Dio exception thrown while
/// processing an otherwise-successful response (e.g. a DTO decode/cast
/// mismatch, such as an unexpected paginated-envelope shape).
Future<Result<T>> guardRequest<T>(Future<T> Function() body) async {
  try {
    return Success(await body());
  } on DioException catch (e, st) {
    final failure = e.error;
    if (failure is! Failure) {
      sl<Logger>().e(
        'Unmapped DioException on ${e.requestOptions.method} '
        '${e.requestOptions.path}: type=${e.type}, '
        'status=${e.response?.statusCode}, message=${e.message}',
        e.error ?? e,
        st,
      );
    }
    return ResultFailure(
      failure is Failure ? failure : UnknownFailure(e.message ?? e.toString()),
    );
  } catch (e, st) {
    // Not a network error at all — thrown while processing an already-
    // successful response (decode/cast/format exceptions live here).
    sl<Logger>().e('Unhandled exception processing a request', e, st);
    return ResultFailure(UnknownFailure(e.toString()));
  }
}
