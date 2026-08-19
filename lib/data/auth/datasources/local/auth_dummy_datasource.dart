import '../../../../core/config/app_config.dart';
import '../../../../domain/auth/entities/user_role.dart';
import '../../../../domain/common/failure.dart';
import '../../models/auth_session_dto.dart';

/// Same method signatures as [AuthRemoteDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class AuthDummyDataSource {
  Future<AuthSessionDto> requestOtp(String phoneNumber, UserRole role);

  Future<AuthSessionDto> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  );
}

/// Simulated OTP flow: any phone number "receives" `AppConfig.otpCode` as
/// the correct code. Verification tracks a per-(role, phone) attempt count
/// against `AppConfig.otpMaxAttempts`; hitting the max locks that key out
/// for `AppConfig.otpLockoutRestartSeconds` before attempts reset. Failures
/// are thrown as [Failure] subtypes directly so the repository layer can
/// forward them verbatim (e.g. `ValidationFailure`) instead of flattening
/// everything to `UnknownFailure`.
class AuthDummyDataSourceImpl implements AuthDummyDataSource {
  final Map<String, int> _attempts = {};
  final Map<String, DateTime> _lockedUntil = {};

  String _key(String phoneNumber, UserRole role) =>
      '${role.name}:$phoneNumber';

  @override
  Future<AuthSessionDto> requestOtp(String phoneNumber, UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 700));

    // A fresh OTP request resets any prior attempt/lockout state for this
    // (role, phone) pair.
    final key = _key(phoneNumber, role);
    _attempts.remove(key);
    _lockedUntil.remove(key);

    return AuthSessionDto(
      userId: '${role.name}-$phoneNumber',
      role: role,
      phoneNumber: phoneNumber,
      token: null,
    );
  }

  @override
  Future<AuthSessionDto> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  ) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final key = _key(phoneNumber, role);

    final lockedUntil = _lockedUntil[key];
    if (lockedUntil != null) {
      if (DateTime.now().isBefore(lockedUntil)) {
        final remaining = lockedUntil.difference(DateTime.now()).inSeconds;
        throw ValidationFailure(
          'Too many incorrect attempts. Try again in '
          '${remaining <= 0 ? 1 : remaining}s.',
        );
      }
      // Lockout window elapsed — reset and allow another round of attempts.
      _lockedUntil.remove(key);
      _attempts.remove(key);
    }

    if (otp != AppConfig.otpCode) {
      final attempts = (_attempts[key] ?? 0) + 1;
      _attempts[key] = attempts;

      if (attempts >= AppConfig.otpMaxAttempts) {
        _lockedUntil[key] = DateTime.now().add(
          const Duration(seconds: AppConfig.otpLockoutRestartSeconds),
        );
        throw ValidationFailure(
          'Too many incorrect attempts. Try again in '
          '${AppConfig.otpLockoutRestartSeconds}s.',
        );
      }

      final remainingAttempts = AppConfig.otpMaxAttempts - attempts;
      throw ValidationFailure(
        'Incorrect code. $remainingAttempts attempt(s) remaining.',
      );
    }

    _attempts.remove(key);
    _lockedUntil.remove(key);

    return AuthSessionDto(
      userId: '${role.name}-$phoneNumber',
      role: role,
      phoneNumber: phoneNumber,
      token:
          'dummy-token-${role.name}-$phoneNumber-'
          '${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
