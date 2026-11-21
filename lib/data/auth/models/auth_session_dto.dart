import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

/// Data-layer DTO mirroring the wire shape of the `POST /auth/google`
/// response (also what's persisted to secure storage).
@freezed
abstract class AuthSessionDto with _$AuthSessionDto {
  const factory AuthSessionDto({
    String? userId,
    required UserRole role,
    String? email,
    String? name,
    String? token,
    String? status,
  }) = _AuthSessionDto;

  const AuthSessionDto._();

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  AuthSession toDomain() => AuthSession(
    userId: userId,
    role: role,
    email: email,
    name: name,
    token: token,
    status: status,
  );

  factory AuthSessionDto.fromDomain(AuthSession entity) => AuthSessionDto(
    userId: entity.userId,
    role: entity.role,
    email: entity.email,
    name: entity.name,
    token: entity.token,
    status: entity.status,
  );
}
