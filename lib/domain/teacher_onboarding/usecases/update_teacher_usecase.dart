import '../../common/result.dart';
import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

/// Single-purpose use case for the `teacher-profile` "Edit profile" action
/// (§10.2). Only name/phone are expected to differ from what's already
/// stored — campus/subjects/classes/approval-status/earnings are read-only
/// here.
class UpdateTeacherUseCase {
  const UpdateTeacherUseCase(this._repository);

  final TeacherRepository _repository;

  Future<Result<Teacher>> call(Teacher teacher) =>
      _repository.updateTeacher(teacher);
}
