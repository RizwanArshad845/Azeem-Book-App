import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/network/result_guard.dart';
import '../../../core/services/logger.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../datasources/google_sign_in_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_session_dto.dart';

/// Owns the two auth side effects other layers must never trigger directly:
/// stamping the outgoing-request token (`AuthInterceptor.currentToken`) and
/// persisting the session (via `flutter_secure_storage`) so it survives app
/// restarts.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.google,
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _sessionKey = 'auth_session';

  final AuthRemoteDataSource remote;
  final GoogleSignInDataSource google;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<Result<AuthSession?>> signInWithGoogle(UserRole role) async {
    final String? idToken;
    try {
      idToken = await google.getIdToken();
    } on GoogleSignInException catch (e, st) {
      sl<Logger>().e('Google Sign-In failed: ${e.code}', e, st);
      return ResultFailure(GoogleSignInFailure(e.description));
    } catch (e, st) {
      sl<Logger>().e('Google Sign-In failed', e, st);
      return const ResultFailure(GoogleSignInFailure());
    }
    if (idToken == null) return const Success(null);

    final result = await guardRequest(() async {
      final dto = await remote.signInWithGoogle(idToken!, role);
      final session = dto.toDomain();
      AuthInterceptor.currentToken = session.token;
      await _persist(dto);
      return session;
    });
    if (result is ResultFailure<AuthSession>) {
      // The backend refused this account (wrong role, deleted, ...): forget
      // it so "try again" offers the account picker instead of reusing it.
      await _forgetGoogleAccount();
    }
    return result;
  }

  @override
  Future<Result<String?>> refreshSessionStatus() {
    return guardRequest(() async {
      final status = await remote.getSessionStatus();
      if (status != null) {
        final raw = await _secureStorage.read(key: _sessionKey);
        if (raw != null) {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          json['status'] = status;
          await _secureStorage.write(key: _sessionKey, value: jsonEncode(json));
        }
      }
      return status;
    });
  }

  @override
  Future<Result<void>> logout() {
    return guardRequest(() async {
      AuthInterceptor.currentToken = null;
      await _secureStorage.delete(key: _sessionKey);
      await _forgetGoogleAccount();
    });
  }

  Future<void> _forgetGoogleAccount() async {
    try {
      await google.signOut();
    } catch (_) {
      // Best-effort: worst case the picker preselects the last account.
    }
  }

  Future<void> _persist(AuthSessionDto dto) =>
      _secureStorage.write(key: _sessionKey, value: jsonEncode(dto.toJson()));

  @override
  Future<Result<AuthSession?>> getStoredSession() {
    return guardRequest(() async {
      final raw = await _secureStorage.read(key: _sessionKey);
      if (raw == null) return null;
      final dto = AuthSessionDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      // A session from the old phone/OTP login has no email: those accounts
      // aren't linked to Google, so drop it and make the user sign in again.
      if (dto.email == null) {
        await _secureStorage.delete(key: _sessionKey);
        return null;
      }
      final session = dto.toDomain();
      // Re-stamp the interceptor token so every subsequent request is
      // authenticated without requiring another sign-in.
      if (session.token != null) {
        AuthInterceptor.currentToken = session.token;
      }
      return session;
    });
  }
}
