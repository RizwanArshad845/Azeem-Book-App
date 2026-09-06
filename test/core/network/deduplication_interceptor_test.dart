import 'dart:convert';
import 'dart:typed_data';

import 'package:azeem_book_app/core/network/interceptors/deduplication_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake adapter that counts invocations and can introduce an artificial
/// delay so concurrent requests genuinely overlap in flight.
class _FakeAdapter implements HttpClientAdapter {
  int callCount = 0;
  Duration delay = const Duration(milliseconds: 30);
  bool shouldThrow = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    final callNumber = callCount;
    await Future<void>.delayed(delay);
    if (shouldThrow) {
      throw DioException(requestOptions: options, error: 'boom');
    }
    return ResponseBody.fromString(
      jsonEncode({'call': callNumber}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _buildDio(_FakeAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.httpClientAdapter = adapter;
  dio.interceptors.add(DeduplicationInterceptor());
  return dio;
}

void main() {
  test('dedupes concurrent identical GET requests into a single call', () async {
    final adapter = _FakeAdapter();
    final dio = _buildDio(adapter);

    final responses = await Future.wait([
      dio.get<Map<String, dynamic>>('/things'),
      dio.get<Map<String, dynamic>>('/things'),
    ]);

    expect(adapter.callCount, 1);
    expect(responses[0].data, responses[1].data);
  });

  test('hits the adapter again for a GET fired after the prior one completed', () async {
    final adapter = _FakeAdapter();
    final dio = _buildDio(adapter);

    await dio.get<Map<String, dynamic>>('/things');
    await dio.get<Map<String, dynamic>>('/things');

    expect(adapter.callCount, 2);
  });

  test('does not dedupe concurrent identical POST requests', () async {
    final adapter = _FakeAdapter();
    final dio = _buildDio(adapter);

    await Future.wait([
      dio.post<Map<String, dynamic>>('/things'),
      dio.post<Map<String, dynamic>>('/things'),
    ]);

    expect(adapter.callCount, 2);
  });

  test('propagates an adapter error to every concurrent caller', () async {
    final adapter = _FakeAdapter()..shouldThrow = true;
    final dio = _buildDio(adapter);

    final future1 = dio.get<Map<String, dynamic>>('/things');
    final future2 = dio.get<Map<String, dynamic>>('/things');

    await expectLater(future1, throwsA(isA<DioException>()));
    await expectLater(future2, throwsA(isA<DioException>()));
    expect(adapter.callCount, 1);
  });
}
