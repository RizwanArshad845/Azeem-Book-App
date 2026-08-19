import '../../common/result.dart';
import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

/// Creates a new self-signup Teacher record (`onboardingSource:
/// selfSignup`, `approvalStatus: pendingAdminApproval`) (§9.1).
class SignUpTeacherUseCase {
  const SignUpTeacherUseCase(this._repository);

  final TeacherRepository _repository;

  Future<Result<Teacher>> call(Teacher teacher) =>
      _repository.signUp(teacher);
}
