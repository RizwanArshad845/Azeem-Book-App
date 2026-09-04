import 'package:freezed_annotation/freezed_annotation.dart';

part 'test.freezed.dart';

/// `kind` of a [Test] (project_spec.md §9.2).
enum TestKind { subjectWiseGuessPaper, subjectWiseSimplePaper, chapterWise }

/// Created by Admin via bulk upload. Scoped by `boardClassId` ->
/// `subjectId`, optionally `chapterId`. May be a scheduled live test
/// (phase-1 beta). Source `.docx` is parsed server-side into structured
/// [Question] records (project_spec.md §9.2).
@freezed
abstract class Test with _$Test {
  const factory Test({
    required String id,
    required String title,
    required TestKind kind,
    required String boardClassId,
    required String subjectId,
    String? chapterId,
    @Default(false) bool isLive,
    DateTime? liveDate,
    @Default(false) bool isFreeSample,
    required DateTime createdAt,
    // Denormalized stats surfaced on test cards / result screen (§9.2). Server
    // derives these from the related [Question] set; kept on [Test] so list
    // cards don't have to load every question just to show a count.
    @Default(0) int questionCount,
    @Default(0) int durationMinutes,
    @Default(0) int totalMarks,
  }) = _Test;
}
