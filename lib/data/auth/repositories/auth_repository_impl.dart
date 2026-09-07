import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/network/result_guard.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/common/result.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_session_dto.dart';

/// Owns the two auth side effects other layers must never trigger directly:
/// stamping the outgoing-request token (`AuthInterceptor.currentToken`) and
/// persisting the session (via `flutter_secure_storage`) so it survives app
/// restarts.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _sessionKey = 'auth_session';

  final AuthRemoteDataSource remote;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<Result<AuthSession>> requestOtp(
    String phoneNumber,
    UserRole role,
  ) {
    return guardRequest(() async {
      final dto = await remote.requestOtp(phoneNumber, role);
      return dto.toDomain();
    });
  }

  @override
  Future<Result<AuthSession>> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  ) {
    return guardRequest(() async {
      final dto = await remote.verifyOtp(phoneNumber, otp, role);
      final session = dto.toDomain();
      AuthInterceptor.currentToken = session.token;
      await _persist(dto);
      return session;
    });
  }

  @override
  Future<Result<void>> logout() {
    return guardRequest(() async {
      AuthInterceptor.currentToken = null;
      await _secureStorage.delete(key: _sessionKey);
    });
  }

  Future<void> _persist(AuthSessionDto dto) =>
      _secureStorage.write(key: _sessionKey, value: jsonEncode(dto.toJson()));

  @override
  Future<Result<void>> requestPhoneChangeOtp(
    String currentPhone,
    String newPhone,
  ) {
    return guardRequest(
      () => remote.requestPhoneChangeOtp(currentPhone, newPhone),
    );
  }

  @override
  Future<Result<void>> verifyPhoneChangeOtp(String newPhone, String otp) {
    return guardRequest(() => remote.verifyPhoneChangeOtp(newPhone, otp));
  }

  @override
  Future<Result<AuthSession?>> getStoredSession() {
    return guardRequest(() async {
      final raw = await _secureStorage.read(key: _sessionKey);
      if (raw == null) return null;
      final dto = AuthSessionDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      final session = dto.toDomain();
      // Re-stamp the interceptor token so every subsequent request is
      // authenticated without requiring another OTP round-trip.
      if (session.token != null) {
        AuthInterceptor.currentToken = session.token;
      }
      return session;
    });
  }
}
