import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/ebook_offline/entities/offline_ebook.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';

/// The saved offline copy of a subject's ebook, local lookup only — used by
/// the offline reader, which must open instantly without any network.
final savedOfflineEbookProvider = FutureProvider.autoDispose
    .family<OfflineEbook?, String>(
      (ref, subjectId) =>
          ref.read(ebookOfflineRepositoryProvider).find(subjectId),
    );

/// The saved offline copy as shown on the Subject Hub, re-validated against
/// the server whenever it's reachable: no longer accessible (refund, ebook
/// withdrawn) → the copy is wiped. Still owned, offline or slow network →
/// the saved copy is kept (a bought bundle never expires).
final offlineEbookProvider = FutureProvider.autoDispose
    .family<OfflineEbook?, String>((ref, subjectId) async {
      final repo = ref.read(ebookOfflineRepositoryProvider);
      final saved = await repo.find(subjectId);
      if (saved == null) return null;

      final EbookAccess access;
      try {
        access = await ref
            .read(ebookForSubjectProvider(subjectId).future)
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        return saved;
      }
      switch (access) {
        case EbookAvailable():
          return saved;
        case EbookLocked() || EbookNotUploaded():
          await repo.remove(subjectId);
          return null;
      }
    });

/// Every saved book, local only — shown on the offline screen so a student
/// with no connection can still open their downloads.
final savedOfflineEbooksProvider =
    FutureProvider.autoDispose<List<OfflineEbook>>(
      (ref) => ref.read(ebookOfflineRepositoryProvider).listSaved(),
    );

/// Progress of an in-flight "Save offline" download: null when idle,
/// otherwise 0.0–1.0.
class EbookDownloadViewModel extends Notifier<double?> {
  EbookDownloadViewModel(this._subjectId);

  final String _subjectId;

  @override
  double? build() => null;

  /// Downloads and encrypts the whole book. Returns whether it succeeded.
  Future<bool> download({required String title}) async {
    if (state != null) return false;
    state = 0;
    final result = await ref
        .read(ebookOfflineRepositoryProvider)
        .download(
          _subjectId,
          title: title,
          onProgress: (done, total) {
            if (ref.mounted) state = total == 0 ? 0 : done / total;
          },
        );
    if (!ref.mounted) return result.isSuccess;
    state = null;
    ref.invalidate(offlineEbookProvider(_subjectId));
    ref.invalidate(savedOfflineEbookProvider(_subjectId));
    ref.invalidate(savedOfflineEbooksProvider);
    return result.isSuccess;
  }

  Future<void> remove() async {
    await ref.read(ebookOfflineRepositoryProvider).remove(_subjectId);
    ref.invalidate(offlineEbookProvider(_subjectId));
    ref.invalidate(savedOfflineEbookProvider(_subjectId));
    ref.invalidate(savedOfflineEbooksProvider);
  }
}

final ebookDownloadViewModelProvider =
    NotifierProvider.family<EbookDownloadViewModel, double?, String>(
      EbookDownloadViewModel.new,
    );
