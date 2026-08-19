import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_class.freezed.dart';

/// Admin-managed catalog entity — a leaf group under a [ClassLevel] (e.g.
/// "Pre-Medical", "Pre-Engineering", or just "9th" for class levels that
/// don't split into groups). Only `isEnabled` board/classes are selectable
/// by students/teachers; others render as "coming soon" (project_spec.md
/// §9.2).
@freezed
abstract class BoardClass with _$BoardClass {
  const factory BoardClass({
    required String id,
    required String name,
    required String classLevelId,
    @Default(false) bool isEnabled,
  }) = _BoardClass;
}
