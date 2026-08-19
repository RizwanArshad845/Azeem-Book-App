import '../../common/result.dart';
import '../entities/live_test_registration.dart';
import '../repositories/live_test_registration_repository.dart';

/// Every live-test registration a student has made — drives "already
/// registered" / "enter now" state on the live-tests screen.
class GetLiveTestRegistrationsUseCase {
  const GetLiveTestRegistrationsUseCase(this._repository);

  final LiveTestRegistrationRepository _repository;

  Future<Result<List<LiveTestRegistration>>> call(String studentId) =>
      _repository.getRegistrationsForStudent(studentId);
}
