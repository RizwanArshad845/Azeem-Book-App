import 'package:freezed_annotation/freezed_annotation.dart';

part 'ebook_page.freezed.dart';

@freezed
abstract class EbookPage with _$EbookPage {
  const factory EbookPage({
    required int pageNumber,
    required String url,
  }) = _EbookPage;
}

/// A signed-URL window returned by `GET .../ebook/pages` — `pages` is empty
/// (not an error) once `startPage` is past the end of the book.
@freezed
abstract class EbookPageWindow with _$EbookPageWindow {
  const factory EbookPageWindow({
    required List<EbookPage> pages,
    required int expiresInSeconds,
  }) = _EbookPageWindow;
}
