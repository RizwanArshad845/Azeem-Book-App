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
  }) = _Subject;
}
