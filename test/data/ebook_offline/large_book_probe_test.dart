import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:azeem_book_app/data/ebook_offline/repositories/ebook_offline_repository_impl.dart';
import 'package:azeem_book_app/domain/catalog/entities/ebook.dart';
import 'package:azeem_book_app/domain/catalog/entities/ebook_page.dart';
import 'package:azeem_book_app/domain/catalog/repositories/catalog_repository.dart';
import 'package:azeem_book_app/domain/common/failure.dart';
import 'package:azeem_book_app/domain/common/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

/// Serves each page as 256 bytes; pages in [stallOnce] never respond the
/// first time they're requested (a dead connection).
class _Cdn implements HttpClientAdapter {
  _Cdn({Set<int>? stallOnce}) : stallOnce = stallOnce ?? {};
  final Set<int> stallOnce;

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? s,
    Future<void>? c,
  ) async {
    final page = int.parse(o.uri.pathSegments.last.split('.').first);
    if (stallOnce.remove(page)) return Completer<ResponseBody>().future;
    return ResponseBody.fromBytes(List.filled(256, page % 256), 200);
  }

  @override
  void close({bool force = false}) {}
}

/// Regression tests for saving a long (986-page) book offline.
void main() {
  const id = 'big';
  const pageCount = 986;
  late Directory root;
  late _MockCatalog catalog;

  void stub({int serverCap = 1000, Set<int> failWindowCalls = const {}}) {
    var calls = 0;
    when(() => catalog.getEbook(id)).thenAnswer(
      (_) async => const Success(
        Ebook(subjectId: id, status: EbookStatus.ready, pageCount: pageCount),
      ),
    );
    when(
      () => catalog.getEbookPages(
        id,
        startPage: any(named: 'startPage'),
        count: any(named: 'count'),
      ),
    ).thenAnswer((inv) async {
      calls++;
      if (failWindowCalls.contains(calls)) {
        return const ResultFailure(NetworkFailure());
      }
      final start = inv.namedArguments[#startPage] as int;
      final count = (inv.namedArguments[#count] as int).clamp(1, serverCap);
      final end = (start + count - 1).clamp(0, pageCount);
      return Success(
        EbookPageWindow(
          pages: [
            for (var p = start; p <= end; p++)
              EbookPage(pageNumber: p, url: 'https://cdn.test/$p.webp'),
          ],
          expiresInSeconds: 300,
        ),
      );
    });
  }

  EbookOfflineRepositoryImpl repo(_Cdn cdn) {
    // Capture this test's root so nothing can leak into another test's.
    final dir = root;
    return EbookOfflineRepositoryImpl(
      catalog: catalog,
      downloader: Dio()..httpClientAdapter = cdn,
      rootDirectory: () async => dir,
      pageTimeout: const Duration(seconds: 1),
    );
  }

  Future<void> expectAllPagesReadable(EbookOfflineRepositoryImpl r) async {
    for (final p in [1, 15, 500, 981, 986]) {
      expect(await r.readPage(id, p), List.filled(256, p % 256));
    }
  }

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    root = await Directory.systemTemp.createTemp('big_book');
    catalog = _MockCatalog();
  });
  tearDown(() async {
    try {
      await root.delete(recursive: true);
    } on FileSystemException {
      // Windows can briefly hold handles; temp dir cleanup is best-effort.
    }
  });

  test('downloads every page of a 986-page book', () async {
    stub();
    final r = repo(_Cdn());
    final progress = <int>[];

    final result = await r.download(id, onProgress: (d, _) => progress.add(d));

    expect(result.isSuccess, isTrue);
    expect(progress.last, pageCount);
    await expectAllPagesReadable(r);
  });

  test('a transient failure fetching the page list is retried', () async {
    stub(failWindowCalls: {30});
    final r = repo(_Cdn());

    final result = await r.download(id);

    expect(result.isSuccess, isTrue);
    await expectAllPagesReadable(r);
  });

  test('a server that returns fewer pages than asked loses no pages',
      () async {
    stub(serverCap: 10);
    final r = repo(_Cdn());

    final result = await r.download(id);

    expect(result.isSuccess, isTrue);
    await expectAllPagesReadable(r);
  });

  test('a stalled page times out and is retried instead of hanging',
      () async {
    stub();
    final r = repo(_Cdn(stallOnce: {500}));

    final result = await r
        .download(id)
        .timeout(const Duration(seconds: 30));

    expect(result.isSuccess, isTrue);
    await expectAllPagesReadable(r);
  });
}
