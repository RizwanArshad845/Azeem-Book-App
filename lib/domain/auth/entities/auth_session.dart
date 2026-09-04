import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'auth_session.freezed.dart';

/// Session primitive established by the generic role-select -> phone ->
/// OTP-verify flow: "this phone number, verified via OTP, is acting as role
/// X, with session token Y." Deliberately does not know about Teacher/Student
/// profile completeness — that's layered on by teacher-onboarding /
/// student-onboarding in the next batch, which will read this via
/// `currentUserProvider`.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    // Nullable: `POST /auth/otp/request` returns `userId: null` (no profile
    // exists yet) — only `POST /auth/otp/verify` guarantees a non-null id
    // (`FRONTEND_INTEGRATION.md` §6.1). Callers that only ever read a
    // post-verify session may assert non-null.
    String? userId,
    required UserRole role,
    required String phoneNumber,
    // Nullable until a real backend issues one; dummy mode synthesizes a
    // fake token string on successful OTP verification (§6.1).
    String? token,
  }) = _AuthSession;
}
