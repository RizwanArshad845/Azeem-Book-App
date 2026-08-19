import '../../common/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: verify an OTP for a phone number acting as a
/// given role, producing a session on success.
class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call(
    String phoneNumber,
    String otp,
    UserRole role,
  ) => _repository.verifyOtp(phoneNumber, otp, role);
}
