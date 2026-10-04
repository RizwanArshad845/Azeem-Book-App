import '../../common/result.dart';
import '../entities/subject_enrollment.dart';
import '../repositories/student_repository.dart';

/// Sets, changes, or removes (null `teacherId`) the teacher for one enrolled
/// subject via `PATCH /students/{id}/subject-enrollments/{subjectId}`. Only
/// allowed until that subject's bundle is bought.
class SetStudentSubjectTeacherUseCase {
  const SetStudentSubjectTeacherUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<SubjectEnrollment>> call(
    String studentId,
    String subjectId,
    String? teacherId,
  ) => _repository.setSubjectTeacher(studentId, subjectId, teacherId);
}
