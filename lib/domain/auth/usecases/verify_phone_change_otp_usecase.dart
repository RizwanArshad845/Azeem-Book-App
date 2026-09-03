import '../../common/result.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: verify the OTP sent to [newPhone] before the
/// caller commits the phone-number edit via `UpdateTeacherUseCase`.
class VerifyPhoneChangeOtpUseCase {
  const VerifyPhoneChangeOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(String newPhone, String otp) =>
      _repository.verifyPhoneChangeOtp(newPhone, otp);
}
