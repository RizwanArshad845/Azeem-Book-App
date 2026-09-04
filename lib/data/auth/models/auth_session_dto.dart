import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of `/auth/otp/request` and
/// `/auth/otp/verify` responses.
@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const factory AuthSessionDto({
    // Nullable: `POST /auth/otp/request` returns `userId: null`.
    String? userId,
    required UserRole role,
    required String phoneNumber,
    String? token,
  }) = _AuthSessionDto;

  const AuthSessionDto._();

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  AuthSession toDomain() => AuthSession(
    userId: userId,
    role: role,
    phoneNumber: phoneNumber,
    token: token,
  );

  factory AuthSessionDto.fromDomain(AuthSession entity) => AuthSessionDto(
    userId: entity.userId,
    role: entity.role,
    phoneNumber: entity.phoneNumber,
    token: entity.token,
  );
}
