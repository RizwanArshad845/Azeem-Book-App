import '../../common/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_role.dart';

/// Zero Flutter/Riverpod/package dependencies per §2 Clean Architecture
/// rules. Auth is passwordless — phone number + OTP only (§9.1) — for
/// Teacher and Student roles.
abstract class AuthRepository {
  /// Triggers sending an OTP to [phoneNumber] for the given [role]. Returns
  /// an unverified [AuthSession] stub (null `token`) on success so the view
  /// layer knows the request succeeded before moving to OTP entry.
  Future<Result<AuthSession>> requestOtp(String phoneNumber, UserRole role);

  /// Verifies [otp] for [phoneNumber]/[role]. On success returns a fully
  /// populated [AuthSession] (non-null `token`).
  Future<Result<AuthSession>> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  );

  /// Clears the current session (interceptor token + persisted storage).
  Future<Result<void>> logout();

  /// Triggers sending an OTP to [newPhone] so a signed-in user can confirm a
  /// phone-number change away from [currentPhone] (`teacher-profile`'s
  /// phone-edit flow).
  Future<Result<void>> requestPhoneChangeOtp(
    String currentPhone,
    String newPhone,
  );

  /// Verifies the OTP sent to [newPhone] before the caller commits the
  /// phone-number edit.
  Future<Result<void>> verifyPhoneChangeOtp(String newPhone, String otp);
}
