import '../../common/result.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

/// Single-purpose use case for the `student-profile` "Edit profile" action
/// (§10.2). Only name/phone are expected to differ from what's already
/// stored — campus/board-class/subject enrollments are read-only here.
class UpdateStudentUseCase {
  const UpdateStudentUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<Student>> call(Student student) =>
      _repository.updateStudent(student);
}
