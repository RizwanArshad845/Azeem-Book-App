import '../../common/result.dart';
import '../entities/subject_enrollment.dart';
import '../repositories/student_repository.dart';

/// Persists updated subject enrollments (e.g. assigning or changing a teacher)
/// for a student via `PUT /students/{id}/subject-enrollments`.
class UpdateStudentSubjectEnrollmentsUseCase {
  const UpdateStudentSubjectEnrollmentsUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<List<SubjectEnrollment>>> call(
    String studentId,
    List<SubjectEnrollment> enrollments,
  ) =>
      _repository.updateSubjectEnrollments(studentId, enrollments);
}
