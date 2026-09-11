import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';

/// Ordered syllabus unit belonging to a Subject. Drives "first chapter
/// free" (`order == 1`) and chapter-wise navigation/reporting
/// (project_spec.md §9.2).
@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String subjectId,
    required String title,
    required int order,
    @Default(false) bool isFreeSample,
    String? youtubeUrl,
  }) = _Chapter;
}
