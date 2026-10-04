import '../../common/result.dart';
import '../entities/subject_enrollment.dart';
import '../repositories/student_repository.dart';

/// Adds one subject (teacher optional) via
/// `POST /students/{id}/subject-enrollments`, leaving the student's other
/// subjects untouched.
class AddStudentSubjectEnrollmentUseCase {
  const AddStudentSubjectEnrollmentUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<SubjectEnrollment>> call(
    String studentId,
    String subjectId, {
    String? teacherId,
  }) => _repository.addSubjectEnrollment(
    studentId,
    subjectId,
    teacherId: teacherId,
  );
}
