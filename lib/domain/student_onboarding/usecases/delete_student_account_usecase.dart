import '../../common/result.dart';
import '../repositories/student_repository.dart';

/// Single-purpose use case for the `student-profile` "Delete account"
/// action (§10.2). Soft-deletes only — see `StudentRepository.deleteAccount`.
class DeleteStudentAccountUseCase {
  const DeleteStudentAccountUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<void>> call(String studentId) =>
      _repository.deleteAccount(studentId);
}
