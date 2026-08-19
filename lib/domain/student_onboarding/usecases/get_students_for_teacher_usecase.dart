import '../../common/result.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

/// Fetches every student enrolled with a given teacher (project_spec.md
/// §9.2 `SubjectEnrollment.teacherId`). Consumed by `teacher-students`
/// (Students tab list + per-student progress detail).
class GetStudentsForTeacherUseCase {
  const GetStudentsForTeacherUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<List<Student>>> call(String teacherId) =>
      _repository.getStudentsForTeacher(teacherId);
}
