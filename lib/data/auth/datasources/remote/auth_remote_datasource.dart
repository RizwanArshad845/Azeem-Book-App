import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/auth/entities/user_role.dart';
import '../../models/auth_session_dto.dart';

abstract class AuthRemoteDataSource {
  /// `POST /auth/google` — exchanges a Google ID token for our own session
  /// (JWT + routing `status`).
  Future<AuthSessionDto> signInWithGoogle(String idToken, UserRole role);

  /// `GET /auth/session-status` — the routing `status` for the current token
  /// (`NOT_REGISTERED`/`ONBOARDING`/`PENDING_APPROVAL`/`DASHBOARD`), or `null`
  /// if the response carries none. Only the status is read: this response
  /// must never overwrite the stored token/userId.
  Future<String?> getSessionStatus();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthSessionDto> signInWithGoogle(String idToken, UserRole role) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authGoogle,
      data: {'idToken': idToken, 'role': role.name},
    );
    return AuthSessionDto.fromJson(response.data ?? const {});
  }

  @override
  Future<String?> getSessionStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.authSessionStatus,
    );
    final status = response.data?['status'];
    return status is String ? status : null;
  }
}
