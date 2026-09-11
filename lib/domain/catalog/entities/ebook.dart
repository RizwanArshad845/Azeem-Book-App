import 'package:freezed_annotation/freezed_annotation.dart';

part 'ebook.freezed.dart';

/// Server-side conversion status of a Subject's single admin-uploaded
/// ebook PDF into page images (see backend.md — page-streaming ebook
/// viewer design).
enum EbookStatus { pending, processing, ready, failed }

@freezed
abstract class Ebook with _$Ebook {
  const factory Ebook({
    required String subjectId,
    required EbookStatus status,
    int? pageCount,
  }) = _Ebook;
}
