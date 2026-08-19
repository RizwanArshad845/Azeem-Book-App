import '../../common/result.dart';
import '../repositories/teacher_repository.dart';

/// Single-purpose use case for the `teacher-profile` "Delete account"
/// action (§10.2, applied for parity with `student-profile` per §9.1's
/// narrative text). Soft-deletes only — see `TeacherRepository.deleteAccount`.
class DeleteTeacherAccountUseCase {
  const DeleteTeacherAccountUseCase(this._repository);

  final TeacherRepository _repository;

  Future<Result<void>> call(String teacherId) =>
      _repository.deleteAccount(teacherId);
}
