import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../datasources/local/auth_dummy_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_session_dto.dart';

/// Switches between the dummy and remote datasource per
/// `AppConfig.isMockMode` (§6.1/§6.2) — never called with a live endpoint
/// directly from a viewmodel. Also owns the two auth side effects other
/// layers must never trigger directly: stamping the outgoing-request token
/// (`AuthInterceptor.currentToken`) and persisting the session (via
/// `flutter_secure_storage`) so it survives app restarts.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.dummy,
    required this.isMockMode,
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _sessionKey = 'auth_session';

  final AuthRemoteDataSource remote;
  final AuthDummyDataSource dummy;
  final bool isMockMode;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<Result<AuthSession>> requestOtp(
    String phoneNumber,
    UserRole role,
  ) async {
    try {
      final dto = isMockMode
          ? await dummy.requestOtp(phoneNumber, role)
          : await remote.requestOtp(phoneNumber, role);
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
      final dto = isMockMode
          ? await dummy.verifyOtp(phoneNumber, otp, role)
          : await remote.verifyOtp(phoneNumber, otp, role);
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
}
