import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/catalog/entities/ebook.dart';
import '../../../domain/catalog/entities/ebook_page.dart';
import '../../../domain/catalog/repositories/catalog_repository.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/ebook_offline/entities/offline_ebook.dart';
import '../../../domain/ebook_offline/repositories/ebook_offline_repository.dart';

/// Offline ebook storage. Security model:
/// - Each saved book gets its own random AES-256 key, kept only in
///   `flutter_secure_storage` (Android Keystore / iOS Keychain) together
///   with the book's metadata — never next to the page files.
/// - Every page is stored AES-GCM encrypted in the app-private support
///   directory, bound (via associated data) to its subject + page number,
///   so copied, swapped or edited files fail to decrypt.
/// - Pages are decrypted to memory only, at read time.
/// - No expiry: a bought bundle is permanent. Copies are removed only when
///   the server revokes access (checked while online), on request, or on
///   logout.
class EbookOfflineRepositoryImpl implements EbookOfflineRepository {
  EbookOfflineRepositoryImpl({
    required this.catalog,
    Dio? downloader,
    FlutterSecureStorage? secureStorage,
    Future<Directory> Function()? rootDirectory,
    DateTime Function()? clock,
  }) : // Bare client on purpose: page URLs are pre-signed, so the auth
       // token must not be sent to the storage/CDN host.
       _downloader = downloader ?? Dio(),
       _storage = secureStorage ?? const FlutterSecureStorage(),
       _rootDirectory = rootDirectory ?? getApplicationSupportDirectory,
       _now = clock ?? DateTime.now;

  static const _windowSize = 20;
  static const _parallelDownloads = 4;
  static const _metaPrefix = 'ebook_offline_';

  final CatalogRepository catalog;
  final Dio _downloader;
  final FlutterSecureStorage _storage;
  final Future<Directory> Function() _rootDirectory;
  final DateTime Function() _now;
  final _cipher = AesGcm.with256bits();

  // Decoded keys for books opened this session, so paging doesn't hit the
  // Keystore for every page.
  final Map<String, SecretKey> _keyCache = {};

  @override
  Future<Result<OfflineEbook>> download(
    String subjectId, {
    String title = '',
    void Function(int done, int total)? onProgress,
  }) async {
    final ebookResult = await catalog.getEbook(subjectId);
    final Ebook ebook;
    switch (ebookResult) {
      case Success(:final data):
        ebook = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }
    final pageCount = ebook.pageCount ?? 0;
    if (ebook.status != EbookStatus.ready || pageCount <= 0) {
      return const ResultFailure(NotFoundFailure('Ebook is not ready.'));
    }

    await remove(subjectId);
    final dir = await _bookDir(subjectId);
    await dir.create(recursive: true);
    final key = await _cipher.newSecretKey();

    try {
      var done = 0;
      onProgress?.call(0, pageCount);
      for (var start = 1; start <= pageCount; start += _windowSize) {
        var pending = await _fetchWindow(subjectId, start);
        // A signed URL can expire mid-download — retry the failed pages once
        // with a freshly signed window.
        for (var attempt = 0; attempt < 2 && pending.isNotEmpty; attempt++) {
          if (attempt > 0) {
            final fresh = await _fetchWindow(subjectId, start);
            final failedNumbers = pending.map((p) => p.pageNumber).toSet();
            pending = fresh
                .where((p) => failedNumbers.contains(p.pageNumber))
                .toList();
          }
          final failed = <EbookPage>[];
          for (var i = 0; i < pending.length; i += _parallelDownloads) {
            final batch = pending.skip(i).take(_parallelDownloads).toList();
            final ok = await Future.wait(
              batch.map((p) => _downloadPage(subjectId, p, key, dir)),
            );
            for (var j = 0; j < batch.length; j++) {
              if (ok[j]) {
                done++;
                onProgress?.call(done, pageCount);
              } else {
                failed.add(batch[j]);
              }
            }
          }
          pending = failed;
        }
        if (pending.isNotEmpty) {
          throw const NetworkFailure('Some pages failed to download.');
        }
      }

      final meta = _Meta(
        key: base64Encode(await key.extractBytes()),
        title: title,
        pageCount: pageCount,
        downloadedAt: _now().toUtc(),
      );
      // Metadata is written last: its presence is what marks the book as
      // completely saved.
      await _writeMeta(meta, subjectId);
      _keyCache[subjectId] = key;
      return Success(meta.toEntity(subjectId));
    } on Failure catch (f) {
      await remove(subjectId);
      return ResultFailure(f);
    } on DioException {
      await remove(subjectId);
      return const ResultFailure(NetworkFailure());
    } catch (e) {
      await remove(subjectId);
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  Future<List<EbookPage>> _fetchWindow(String subjectId, int start) async {
    final result = await catalog.getEbookPages(
      subjectId,
      startPage: start,
      count: _windowSize,
    );
    return switch (result) {
      Success(:final data) => data.pages,
      ResultFailure(:final failure) => throw failure,
    };
  }

  Future<bool> _downloadPage(
    String subjectId,
    EbookPage page,
    SecretKey key,
    Directory dir,
  ) async {
    try {
      final response = await _downloader.get<List<int>>(
        page.url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) return false;
      final box = await _cipher.encrypt(
        bytes,
        secretKey: key,
        aad: _aad(subjectId, page.pageNumber),
      );
      await File(_pagePath(dir, page.pageNumber))
          .writeAsBytes(box.concatenation(), flush: true);
      return true;
    } on DioException {
      return false;
    }
  }

  @override
  Future<OfflineEbook?> find(String subjectId) async {
    final meta = await _readMeta(subjectId);
    return meta?.toEntity(subjectId);
  }

  @override
  Future<List<OfflineEbook>> listSaved() async {
    final all = await _storage.readAll();
    return [
      for (final MapEntry(:key, :value) in all.entries)
        if (key.startsWith(_metaPrefix))
          _Meta.fromJson(
            jsonDecode(value) as Map<String, dynamic>,
          ).toEntity(key.substring(_metaPrefix.length)),
    ]..sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Future<Uint8List> readPage(String subjectId, int pageNumber) async {
    final key = await _keyFor(subjectId);
    final dir = await _bookDir(subjectId);
    final data = await File(_pagePath(dir, pageNumber)).readAsBytes();
    final box = SecretBox.fromConcatenation(
      data,
      nonceLength: _cipher.nonceLength,
      macLength: _cipher.macAlgorithm.macLength,
      copy: false,
    );
    final clear = await _cipher.decrypt(
      box,
      secretKey: key,
      aad: _aad(subjectId, pageNumber),
    );
    return Uint8List.fromList(clear);
  }

  @override
  Future<void> remove(String subjectId) async {
    _keyCache.remove(subjectId);
    await _storage.delete(key: '$_metaPrefix$subjectId');
    final dir = await _bookDir(subjectId);
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  @override
  Future<void> removeAll() async {
    _keyCache.clear();
    final all = await _storage.readAll();
    final keys = all.keys.where((k) => k.startsWith(_metaPrefix)).toList();
    for (final k in keys) {
      await _storage.delete(key: k);
    }
    final root = Directory('${(await _rootDirectory()).path}/ebooks');
    if (await root.exists()) await root.delete(recursive: true);
  }

  Future<SecretKey> _keyFor(String subjectId) async {
    final cached = _keyCache[subjectId];
    if (cached != null) return cached;
    final meta = await _readMeta(subjectId);
    if (meta == null) throw StateError('No offline copy of $subjectId');
    return _keyCache[subjectId] = SecretKey(base64Decode(meta.key));
  }

  Future<Directory> _bookDir(String subjectId) async =>
      Directory('${(await _rootDirectory()).path}/ebooks/$subjectId');

  String _pagePath(Directory dir, int pageNumber) =>
      '${dir.path}/$pageNumber.bin';

  List<int> _aad(String subjectId, int pageNumber) =>
      utf8.encode('$subjectId:$pageNumber');

  Future<_Meta?> _readMeta(String subjectId) async {
    final raw = await _storage.read(key: '$_metaPrefix$subjectId');
    if (raw == null) return null;
    return _Meta.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _writeMeta(_Meta meta, String subjectId) => _storage.write(
    key: '$_metaPrefix$subjectId',
    value: jsonEncode(meta.toJson()),
  );
}

class _Meta {
  const _Meta({
    required this.key,
    required this.title,
    required this.pageCount,
    required this.downloadedAt,
  });

  factory _Meta.fromJson(Map<String, dynamic> json) => _Meta(
    key: json['key'] as String,
    title: json['title'] as String? ?? '',
    pageCount: json['pageCount'] as int,
    downloadedAt: DateTime.parse(json['downloadedAt'] as String),
  );

  final String key;
  final String title;
  final int pageCount;
  final DateTime downloadedAt;

  OfflineEbook toEntity(String subjectId) => OfflineEbook(
    subjectId: subjectId,
    title: title,
    pageCount: pageCount,
    downloadedAt: downloadedAt,
  );

  Map<String, dynamic> toJson() => {
    'key': key,
    'title': title,
    'pageCount': pageCount,
    'downloadedAt': downloadedAt.toIso8601String(),
  };
}
