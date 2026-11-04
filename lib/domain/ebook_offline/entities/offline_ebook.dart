import 'package:freezed_annotation/freezed_annotation.dart';

part 'offline_ebook.freezed.dart';

/// An ebook whose pages are stored encrypted on this device. A purchased
/// bundle is permanent, so a saved copy never expires — it's only removed
/// when the server stops granting access (refund / ebook withdrawn, checked
/// whenever the student is online), on "Remove download", or on logout.
@freezed
abstract class OfflineEbook with _$OfflineEbook {
  const factory OfflineEbook({
    required String subjectId,

    /// Subject name captured at download time, so saved books can be listed
    /// with no network.
    @Default('') String title,
    required int pageCount,
    required DateTime downloadedAt,
  }) = _OfflineEbook;
}
