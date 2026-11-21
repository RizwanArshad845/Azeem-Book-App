import '../../common/result.dart';
import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

/// Looks up the signed-in teacher's own record by user id — the first step
/// of the onboarding flow. `null` means no record yet (show the self-signup
/// form); an admin-seeded record is already linked to this id by the
/// backend's Google login (§9.1).
class GetTeacherByIdUseCase {
  const GetTeacherByIdUseCase(this._repository);

  final TeacherRepository _repository;

  Future<Result<Teacher?>> call(String teacherId) =>
      _repository.getTeacherById(teacherId);
}
