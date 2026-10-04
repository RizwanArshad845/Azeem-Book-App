import 'package:flutter/foundation.dart';

/// Slot the network layer fires into when a request comes back `401`, without
/// the network layer itself knowing what "handle a 401" means (that's a
/// presentation/auth concern). `main.dart` (the composition root) is the only
/// place that fills this in — mirrors how `AuthInterceptor.currentToken` lets
/// a higher layer feed the network layer state without an import cycle.
class SessionExpiryNotifier {
  const SessionExpiryNotifier._();

  static VoidCallback? onUnauthorized;

  /// Fired when the backend answers `account_deleted` (403 on login/signup,
  /// 401 on a normal call). The argument is whether the failing request was
  /// carrying the current session's token — i.e. whether the local session
  /// must be cleared too — so the composition root can log out and show the
  /// blocking dialog.
  static void Function({required bool clearSession})? onAccountDeleted;
}
