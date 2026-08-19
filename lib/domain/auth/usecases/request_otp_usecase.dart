import '../../common/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: request an OTP for a phone number acting as a
/// given role.
class RequestOtpUseCase {
  const RequestOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call(String phoneNumber, UserRole role) =>
      _repository.requestOtp(phoneNumber, role);
}
