import '../../common/result.dart';
import '../entities/live_test_registration.dart';
import '../repositories/live_test_registration_repository.dart';

/// Registers a student's interest in an already Admin-scheduled live test.
/// Single-purpose use case per CLAUDE.md §1 — the view/viewmodel is
/// responsible for only calling this against a `Test` with `isLive == true`
/// (this use case trusts the `testId` it's given, matching how
/// `AddToCartUseCase` trusts the `Test` passed to it).
class RegisterForLiveTestUseCase {
  const RegisterForLiveTestUseCase(this._repository);

  final LiveTestRegistrationRepository _repository;

  Future<Result<LiveTestRegistration>> call({
    required String studentId,
    required String testId,
  }) => _repository.registerForLiveTest(studentId: studentId, testId: testId);
}
