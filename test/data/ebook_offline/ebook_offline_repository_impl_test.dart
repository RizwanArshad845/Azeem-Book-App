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

/// Serves `https://cdn.test/<page>.webp` as 64 bytes filled with the page
/// number; any page listed in [failing] returns 403 once (an expired URL).
class _FakeCdn implements HttpClientAdapter {
  _FakeCdn({Set<int>? failing}) : failing = failing ?? {};

  final Set<int> failing;
  int requests = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests++;
    final page = int.parse(options.uri.pathSegments.last.split('.').first);
    if (failing.remove(page)) return ResponseBody.fromBytes([], 403);
    return ResponseBody.fromBytes(List.filled(64, page), 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const subjectId = 'sub-1';
  late Directory root;
  late _MockCatalog catalog;
  late DateTime now;

  EbookOfflineRepositoryImpl build(_FakeCdn cdn) => EbookOfflineRepositoryImpl(
    catalog: catalog,
    downloader: Dio()..httpClientAdapter = cdn,
    rootDirectory: () async => root,
    clock: () => now,
  );

  void stubBook(int pageCount) {
    when(() => catalog.getEbook(subjectId)).thenAnswer(
      (_) async => Success(
        Ebook(
          subjectId: subjectId,
          status: EbookStatus.ready,
          pageCount: pageCount,
        ),
      ),
    );
    when(
      () => catalog.getEbookPages(
        subjectId,
        startPage: any(named: 'startPage'),
        count: any(named: 'count'),
      ),
    ).thenAnswer((inv) async {
      final start = inv.namedArguments[#startPage] as int;
      final count = inv.namedArguments[#count] as int;
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

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    root = await Directory.systemTemp.createTemp('ebook_offline_test');
    catalog = _MockCatalog();
    now = DateTime.utc(2026, 11, 5, 12);
  });

  tearDown(() async {
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('download stores pages encrypted and readPage decrypts them', () async {
    stubBook(25);
    final repo = build(_FakeCdn());
    final progress = <int>[];

    final result = await repo.download(
      subjectId,
      title: 'Physics',
      onProgress: (done, _) => progress.add(done),
    );

    expect(result.isSuccess, isTrue);
    expect(progress.last, 25);
    final page7 = await repo.readPage(subjectId, 7);
    expect(page7, List.filled(64, 7));

    final onDisk = await File('${root.path}/ebooks/$subjectId/7.bin')
        .readAsBytes();
    // 12-byte nonce + 64-byte ciphertext + 16-byte MAC, and the ciphertext
    // is not the plaintext.
    expect(onDisk.length, 12 + 64 + 16);
    expect(onDisk.sublist(12, 12 + 64), isNot(List.filled(64, 7)));
    expect((await repo.listSaved()).single.title, 'Physics');
  });

  test('a tampered page fails authentication', () async {
    stubBook(3);
    final repo = build(_FakeCdn());
    await repo.download(subjectId);

    final file = File('${root.path}/ebooks/$subjectId/2.bin');
    final bytes = await file.readAsBytes();
    bytes[bytes.length ~/ 2] ^= 0xFF;
    await file.writeAsBytes(bytes);

    expect(() => repo.readPage(subjectId, 2), throwsA(anything));
  });

  test('a page file swapped for another page fails to decrypt', () async {
    stubBook(3);
    final repo = build(_FakeCdn());
    await repo.download(subjectId);

    await File('${root.path}/ebooks/$subjectId/1.bin')
        .copy('${root.path}/ebooks/$subjectId/2.bin');

    expect(() => repo.readPage(subjectId, 2), throwsA(anything));
  });

  test('an expired signed URL is retried with a fresh window', () async {
    stubBook(5);
    final cdn = _FakeCdn(failing: {3});
    final repo = build(cdn);

    final result = await repo.download(subjectId);

    expect(result.isSuccess, isTrue);
    expect(await repo.readPage(subjectId, 3), List.filled(64, 3));
  });

  test('a failed download leaves nothing behind', () async {
    when(() => catalog.getEbook(subjectId))
        .thenAnswer((_) async => const ResultFailure(UnauthorizedFailure()));
    final repo = build(_FakeCdn());

    final result = await repo.download(subjectId);

    expect(result.isSuccess, isFalse);
    expect(await repo.find(subjectId), isNull);
  });

  test('a saved book never expires', () async {
    stubBook(2);
    final repo = build(_FakeCdn());
    await repo.download(subjectId);

    now = now.add(const Duration(days: 3650));

    expect(await repo.find(subjectId), isNotNull);
    expect(await repo.readPage(subjectId, 1), List.filled(64, 1));
  });

  test('removeAll wipes files and keys', () async {
    stubBook(2);
    final repo = build(_FakeCdn());
    await repo.download(subjectId);

    await repo.removeAll();

    expect(await repo.listSaved(), isEmpty);
    expect(await Directory('${root.path}/ebooks').exists(), isFalse);
  });
}
