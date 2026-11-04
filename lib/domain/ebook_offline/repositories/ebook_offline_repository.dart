import 'dart:typed_data';

import '../../common/result.dart';
import '../entities/offline_ebook.dart';

/// Encrypted, device-bound copies of purchased ebooks for offline reading.
abstract class EbookOfflineRepository {
  /// Downloads every page of [subjectId]'s ebook and stores it encrypted.
  /// Fails (and leaves nothing behind) if the subject isn't owned, the
  /// ebook isn't ready, or any page fails to download.
  Future<Result<OfflineEbook>> download(
    String subjectId, {
    String title = '',
    void Function(int done, int total)? onProgress,
  });

  /// The saved copy of [subjectId], or null if none is saved.
  Future<OfflineEbook?> find(String subjectId);

  /// Every saved book — for the offline screen's list.
  Future<List<OfflineEbook>> listSaved();

  /// Decrypts one page (1-based) into memory. Never writes plaintext to disk.
  Future<Uint8List> readPage(String subjectId, int pageNumber);

  Future<void> remove(String subjectId);

  /// Wipes every saved ebook and its keys (logout / account deletion).
  Future<void> removeAll();
}
