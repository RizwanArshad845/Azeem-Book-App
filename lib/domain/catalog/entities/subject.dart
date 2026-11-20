import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.freezed.dart';

/// Catalog entity (Physics, Chemistry, Computer Science, etc.), always
/// scoped to a `boardClassId` — a subject can never leak across
/// board/classes it doesn't belong to (project_spec.md §9.2).
@freezed
abstract class Subject with _$Subject {
  const factory Subject({
    required String id,
    required String name,
    required String boardClassId,
    required int bundlePrice,
    /// Bundle price minus the 10% teacher-selection discount, when the
    /// requesting student has a teacher assigned for this subject via a
    /// `SubjectEnrollment` — null otherwise (including always-null for
    /// teacher-role callers, per backend contract).
    int? discountedPrice,
    /// Content language: `"en"` (default) or `"ur"`. Urdu subjects render
    /// their content in Nastaleeq, right-to-left (see `UrduAwareText`).
    @Default('en') String language,
  }) = _Subject;

  const Subject._();

  bool get isUrdu => language == 'ur';
}
