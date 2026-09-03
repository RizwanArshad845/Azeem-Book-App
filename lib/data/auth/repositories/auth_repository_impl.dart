import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/common/failure.dart';
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
  ) async {
    try {
      final dto = await remote.requestOtp(phoneNumber, role);
      return Success(dto.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthSession>> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  ) async {
    try {
      final dto = await remote.verifyOtp(phoneNumber, otp, role);
      final session = dto.toDomain();
      AuthInterceptor.currentToken = session.token;
      await _persist(dto);
      return Success(session);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      AuthInterceptor.currentToken = null;
      await _secureStorage.delete(key: _sessionKey);
      return const Success(null);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  Future<void> _persist(AuthSessionDto dto) =>
      _secureStorage.write(key: _sessionKey, value: jsonEncode(dto.toJson()));

  @override
  Future<Result<void>> requestPhoneChangeOtp(
    String currentPhone,
    String newPhone,
  ) async {
    try {
      await remote.requestPhoneChangeOtp(currentPhone, newPhone);
      return const Success(null);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> verifyPhoneChangeOtp(String newPhone, String otp) async {
    try {
      await remote.verifyPhoneChangeOtp(newPhone, otp);
      return const Success(null);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
