import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_class.freezed.dart';

/// Admin-managed catalog entity (e.g. "FSc Pre-Medical", "Matric").
/// Only `isEnabled` board/classes are selectable by students/teachers;
/// others render as "coming soon" (project_spec.md §9.2).
@freezed
abstract class BoardClass with _$BoardClass {
  const factory BoardClass({
    required String id,
    required String name,
    @Default(false) bool isEnabled,
  }) = _BoardClass;
}
