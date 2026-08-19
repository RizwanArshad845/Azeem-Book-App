import 'package:freezed_annotation/freezed_annotation.dart';

part 'campus.freezed.dart';

/// Reference-data entity per project_spec.md §9.2 — used to scope Teacher
/// and Student profiles and to power campus-filtered teacher discovery.
/// `Test` has no `campusId`: tests are never campus-scoped.
@freezed
abstract class Campus with _$Campus {
  const factory Campus({
    required String id,
    required String name,
    required String city,
  }) = _Campus;
}
