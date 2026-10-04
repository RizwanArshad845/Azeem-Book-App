import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/auth/entities/user_role.dart';
import '../../models/auth_session_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionDto> requestOtp(String phoneNumber, UserRole role);

  Future<AuthSessionDto> verifyOtp(
    String phoneNumber,
    String otp,
    UserRole role,
  );

  /// `GET /auth/session-status` — the routing `status` for the current token
  /// (`NOT_REGISTERED`/`ONBOARDING`/`PENDING_APPROVAL`/`DASHBOARD`), or `null`
  /// if the response carries none. Only the status is read: this response
  /// must never overwrite the stored token/userId.
  Future<String?> getSessionStatus();

  /// Sends an OTP to [newPhone] to confirm a phone-number change away from
  /// [currentPhone] (`backend.md` §4.8).
  Future<void> requestPhoneChangeOtp(String currentPhone, String newPhone);

  /// Verifies the OTP sent to [newPhone] (`backend.md` §4.8).
  Future<void> verifyPhoneChangeOtp(String newPhone, String otp);
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

  @override
  Future<String?> getSessionStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.authSessionStatus,
    );
    final status = response.data?['status'];
    return status is String ? status : null;
  }

  @override
  Future<void> requestPhoneChangeOtp(
    String currentPhone,
    String newPhone,
  ) async {
    await _dio.post<void>(
      ApiEndpoints.authPhoneChangeRequest,
      data: {'currentPhone': currentPhone, 'newPhone': newPhone},
    );
  }

  @override
  Future<void> verifyPhoneChangeOtp(String newPhone, String otp) async {
    await _dio.post<void>(
      ApiEndpoints.authPhoneChangeVerify,
      data: {'newPhone': newPhone, 'otp': otp},
    );
  }
}
