import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/auth/entities/user_role.dart';
import '../../models/auth_session_dto.dart';

/// Same method signatures as [AuthDummyDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2). Not
/// exercised while `AppConfig.isMockMode` is true, but kept compiling
/// against real Dio/`ApiEndpoints` signatures so the flag flip is zero-code.
abstract class AuthRemoteDataSource {
  Future<AuthSessionDto> requestOtp(String phoneNumber, UserRole role);

  Future<AuthSessionDto> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthSessionDto> requestOtp(String phoneNumber, UserRole role) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authOtpRequest,
      data: {'phoneNumber': phoneNumber, 'role': role.name},
    );
    return AuthSessionDto.fromJson(response.data ?? const {});
  }

  @override
  Future<AuthSessionDto> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authOtpVerify,
      data: {'phoneNumber': phoneNumber, 'otp': otp, 'role': role.name},
    );
    return AuthSessionDto.fromJson(response.data ?? const {});
  }
}
