import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'auth_session.freezed.dart';

/// Session primitive established by the role-select -> Google Sign-In flow:
/// "this Google account is acting as role X, with session token Y."
/// Deliberately does not know about Teacher/Student profile completeness —
/// that's layered on by teacher-onboarding / student-onboarding, which read
/// this via `currentUserProvider`.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    // `POST /auth/google` always returns one; nullable only so a session
    // persisted by an older app version still decodes.
    String? userId,
    required UserRole role,
    // The Google account's email (lowercased by the backend). Null only for
    // a session persisted by the old OTP login, which must sign in again.
    String? email,
    // Google profile name — prefills the signup form's name field.
    String? name,
    String? token,
    // `POST /auth/google` and `GET /auth/session-status` return this —
    // `NOT_REGISTERED` (no profile row yet, must complete signup/onboarding),
    // `ONBOARDING`, `PENDING_APPROVAL` or `DASHBOARD`. Kept as a raw wire
    // string, not an enum: unrecognized/absent values must fail open to the
    // per-role profile-lookup inference
    // (`student`/`teacherOnboardingViewModelProvider`) rather than crash a
    // strict enum decode.
    String? status,
  }) = _AuthSession;
}
