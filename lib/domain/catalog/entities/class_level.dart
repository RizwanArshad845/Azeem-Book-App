import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_level.freezed.dart';

/// Admin-managed catalog entity representing the actual grade/level a
/// student is in (e.g. "9th", "10th", "11th", "12th"). Only `isEnabled`
/// class levels are selectable by students; others render as "coming soon"
/// (project_spec.md §9.2).
@freezed
abstract class ClassLevel with _$ClassLevel {
  const factory ClassLevel({
    required String id,
    required String name,
    @Default(false) bool isEnabled,
  }) = _ClassLevel;
}
