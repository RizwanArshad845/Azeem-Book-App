import '../../common/result.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

/// Single-purpose use case that submits the fully-assembled [Student]
/// (campus + optional board/class + subject enrollments) at the end of the
/// 3-step onboarding flow.
class CompleteStudentOnboardingUseCase {
  const CompleteStudentOnboardingUseCase(this._repository);

  final StudentRepository _repository;

  Future<Result<Student>> call(Student student) =>
      _repository.completeOnboarding(student);
}
