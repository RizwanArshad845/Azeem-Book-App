import '../../common/result.dart';
import '../entities/teacher.dart';
import '../repositories/teacher_repository.dart';

/// Looks up an existing Teacher record by phone number — the first step of
/// the onboarding flow, used to decide seeded-pass-through (record found,
/// already approved) vs. self-signup form (no record yet) (§9.1).
class GetTeacherByPhoneUseCase {
  const GetTeacherByPhoneUseCase(this._repository);

  final TeacherRepository _repository;

  Future<Result<Teacher?>> call(String phoneNumber) =>
      _repository.getTeacherByPhone(phoneNumber);
}
