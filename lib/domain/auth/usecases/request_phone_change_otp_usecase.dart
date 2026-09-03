import '../../common/result.dart';
import '../repositories/auth_repository.dart';

/// Single-purpose use case: request an OTP be sent to [newPhone] so a
/// signed-in user can confirm a phone number change away from [currentPhone].
class RequestPhoneChangeOtpUseCase {
  const RequestPhoneChangeOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(String currentPhone, String newPhone) =>
      _repository.requestPhoneChangeOtp(currentPhone, newPhone);
}
