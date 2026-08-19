import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_option.freezed.dart';

/// THROWAWAY, self-contained stand-in for "teachers at this campus who
/// teach this subject" (used by `subject_teacher_select_view.dart`'s
/// per-subject teacher picker).
///
/// A sibling `teacher-onboarding` unit is building the real `Teacher`
/// entity + repository (`lib/domain/teacher_onboarding/`,
/// `lib/data/teacher_onboarding/`) in parallel right now, with no ordering
/// guarantee — importing from it here would be a race against files that
/// may not exist yet at build time. This minimal entity carries just enough
/// (`id`, `name`, `campusId`, `subjectIds`) to render the picker, backed by
/// a small hardcoded dummy dataset
/// (`lib/data/student_onboarding/datasources/local/teacher_directory_dummy_datasource.dart`).
///
/// Follow-up: once both features exist, replace this whole
/// `teacher_directory_*` slice with a real cross-feature read of the
/// `teacher-onboarding` feature's `Teacher` list. That reconciliation is
/// explicitly out of scope for this unit.
@freezed
abstract class TeacherOption with _$TeacherOption {
  const factory TeacherOption({
    required String id,
    required String name,
    required String campusId,
    required List<String> subjectIds,
  }) = _TeacherOption;
}
