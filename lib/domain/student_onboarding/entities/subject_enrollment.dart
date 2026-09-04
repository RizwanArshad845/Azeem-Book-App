import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_enrollment.freezed.dart';

/// Join entity — Student x Subject x optional Teacher (project_spec.md
/// §9.2 `SubjectEnrollment`). Drives both the teacher-discount rule
/// (discount only if a teacher is selected) and teacher commission
/// attribution.
@freezed
abstract class SubjectEnrollment with _$SubjectEnrollment {
  const SubjectEnrollment._();

  const factory SubjectEnrollment({
    // Nullable: the wire response for `PUT /students/{id}/subject-
    // enrollments` (`FRONTEND_INTEGRATION.md` §6.3) is `{id, subjectId,
    // teacherId, discountApplied}` — no `studentId` (implied by the URL) —
    // this is only populated client-side at construction time via [create].
    String? studentId,
    String? id,
    required String subjectId,
    String? teacherId,
    @Default(false) bool discountApplied,
  }) = _SubjectEnrollment;

  /// Preferred construction path: enforces the teacher-discount business
  /// rule (§9.2 note: "discountApplied true only if teacherId set") at
  /// construction time rather than leaving it to the caller to set
  /// `discountApplied` correctly by hand.
  factory SubjectEnrollment.create({
    required String studentId,
    required String subjectId,
    String? teacherId,
  }) => SubjectEnrollment(
    studentId: studentId,
    subjectId: subjectId,
    teacherId: teacherId,
    discountApplied: teacherId != null,
  );
}
