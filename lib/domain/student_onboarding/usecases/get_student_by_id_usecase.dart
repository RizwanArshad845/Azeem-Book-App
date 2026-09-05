import '../../common/result.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

/// Looks up the current student's own profile by id — the student
/// equivalent of `GetTeacherByPhoneUseCase`, used by
/// `StudentOnboardingViewModel.build()` to re-derive the current student
/// whenever the logged-in session changes.
class GetStudentByIdUseCase {
  const GetStudentByIdUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<Student?>> call(String studentId) =>
      _repository.getStudentById(studentId);
}
