# Backend TODO — OTP Request Rate-Limiting

> Companion to `backend.md` §5 ("OTP Auth Design"), prompted by a Flutter-side
> change: the OTP bottom sheet now has a client-side 60-second resend
> cooldown and a "3 attempts" warning. **That client behavior is UX only —
> it is not a security control** (an app restart resets it, and nothing
> stops a different client from hitting the endpoint directly). This doc
> specifies the real, server-side enforcement the backend needs so the
> client-side UX is backed by something that actually can't be bypassed.
>
> Scope: `/auth/otp/request` primarily (resend/request spam → real SMS-cost
> and abuse risk), plus a note on `/auth/otp/verify` (brute-force guessing)
> which `backend.md` already flags as open but doesn't fully specify.

---

## 1. Correction to `backend.md` §5

`backend.md`'s existing rate-limit bullet references `AppConfig.otpMaxAttempts`
and `otpLockoutRestartSeconds` — **these no longer exist** in the Flutter
codebase. The current (as of this doc) client-side constants are:

```dart
// lib/core/config/app_config.dart
static const int otpResendCooldownSeconds = 60;
static const int otpMaxResendAttempts = 3;
```

used only by `OtpTimerViewModel`
(`lib/presentation/auth/viewmodel/otp_timer_viewmodel.dart`) to drive the
bottom sheet's countdown text and a warning message — again, **client UX
state only**, reset on app restart, not read or enforced by any backend
call. Don't treat these numbers as a spec to match exactly; they're a
starting point (see §3 below for the actual recommendation).

## 2. The client is already wired for a 429 response — no Flutter changes needed

This is the most important thing to know before implementing: `ErrorInterceptor`
(`lib/core/network/interceptors/error_interceptor.dart`) **already** maps a
`429` response to a `ValidationFailure`, which the OTP screens already
render via the existing error UI (`AppErrorView`/`AppSnackbar`):

```dart
if (statusCode == 429) {
  return ValidationFailure(
    serverMessage ??
        'Too many attempts. Please wait a moment before trying again.',
  );
}
```

`serverMessage` is pulled from the response body if it matches the shape
already documented in `backend.md` §4.9 and `FRONTEND_INTEGRATION.md` §4:

```json
{ "error": { "code": "otp_rate_limited", "message": "Too many requests — try again in 42s." } }
```

**So: as long as the backend returns `429` with this exact `{"error":
{"code", "message"}}` shape on both `/auth/otp/request` and
`/auth/otp/verify`, it will surface correctly in the app with zero Flutter
code changes.** Use a distinct `code` per case (e.g. `otp_rate_limited` for
request spam vs. `otp_verify_locked` for repeated wrong-OTP attempts) so a
future client change can branch on it if needed — today the client only
reads `message`, not `code`.

## 3. Required behavior — `POST /auth/otp/request`

Enforce **per-phone-number**, not per-IP alone (a phone number is the real
scarce/abusable resource here — each request costs a real SMS):

- **Minimum spacing**: reject a new request for the same `phoneNumber` if
  the previous one was less than ~45–60 seconds ago. Recommend slightly
  *more lenient* than the client's 60s (e.g. 45s) rather than exactly
  matching it, so ordinary clock drift between client and server doesn't
  produce a confusing "the button says I can resend but the server just
  rejected it" state.
- **Rolling-window cap**: reject beyond N requests per phone number in a
  window — e.g. 5 requests per 15 minutes — independent of the spacing
  rule above (spacing alone doesn't stop someone waiting exactly 45s
  between requests indefinitely).
- **Storage**: a Redis counter/TTL keyed by phone number is the natural
  fit (`django-ratelimit` with a Redis cache backend, or a hand-rolled
  `INCR`+`EXPIRE`) — avoids a DB write on every OTP request. A DB-backed
  counter (e.g. a column on the pending-OTP record) is acceptable too if
  Redis isn't already in the stack; just make sure it's atomic under
  concurrent requests for the same number.
- **Response on trip**: `429`, body `{"error": {"code": "otp_rate_limited",
  "message": "..."}}`. Include a human-readable retry hint in `message`
  (e.g. "Try again in 42 seconds") — the client just displays it verbatim
  today, so put the actual remaining wait time in there rather than a
  generic string.

## 4. `POST /auth/otp/verify` — brute-force guarding (already an open item in `backend.md` §5, specified here)

Separate concern from §3: this guards against guessing the OTP itself, not
against requesting too many OTPs.

- Lock out further verify attempts for a given `phoneNumber` after ~5 wrong
  OTPs against the *same* outstanding OTP (reset the counter when a new OTP
  is issued via `/auth/otp/request`).
- Response: `429` (or `401` if a "locked" state should read as
  unauthorized rather than rate-limited — either maps to a Flutter
  `Failure` type already; `429` maps to `ValidationFailure`, `401` maps to
  `UnauthorizedFailure` per `backend.md` §4.9), with the same
  `{"error": {"code", "message"}}` shape, `code: "otp_verify_locked"`.
- **Found while writing this doc**: `lib/l10n/app_en.arb` / `app_ur.arb`
  already define an `otpTooManyAttempts` string ("Too many attempts.
  Restarting...") that isn't referenced anywhere in
  `lib/presentation/auth/view/otp_verify_view.dart` today — it looks like
  it was added for exactly this lockout case but never wired up. Once this
  backend behavior ships, that's a small separate Flutter follow-up (not
  covered by this doc): branch on the `otp_verify_locked` error code (or
  just detect repeated-401/429-on-verify) and surface that string instead
  of the generic OTP-incorrect message, then reset `OtpDigitBox` similarly
  to how a wrong-OTP `ValidationFailure` already does today via its
  `resetToken` param.

## 5. Out of scope here (already tracked in `backend.md` §5/§7)

- SMS delivery vendor choice.
- Single-IP sign-in enforcement for students vs. multi-device grace period.

Both remain open items to confirm with product, independent of the
rate-limiting behavior specified above.
