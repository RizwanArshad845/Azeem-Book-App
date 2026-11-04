import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../../domain/ebook_offline/repositories/ebook_offline_repository.dart';

/// Image provider for one page of an offline (encrypted) ebook: decrypts the
/// page into memory and decodes it directly, so plaintext never touches
/// disk. Keyed by subject + page, so Flutter's in-memory image cache reuses
/// a decoded page while paging back and forth.
@immutable
class EncryptedPageImage extends ImageProvider<EncryptedPageImage> {
  const EncryptedPageImage({
    required this.repository,
    required this.subjectId,
    required this.pageNumber,
  });

  final EbookOfflineRepository repository;
  final String subjectId;
  final int pageNumber;

  @override
  Future<EncryptedPageImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    EncryptedPageImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _decode(decode),
      scale: 1,
      debugLabel: 'offline-ebook:$subjectId:$pageNumber',
    );
  }

  Future<ui.Codec> _decode(ImageDecoderCallback decode) async {
    final bytes = await repository.readPage(subjectId, pageNumber);
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) =>
      other is EncryptedPageImage &&
      other.subjectId == subjectId &&
      other.pageNumber == pageNumber;

  @override
  int get hashCode => Object.hash(subjectId, pageNumber);
}
