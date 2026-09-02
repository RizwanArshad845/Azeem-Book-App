import 'package:flutter/foundation.dart';

/// Slot the network layer fires into when a request comes back `401`, without
/// the network layer itself knowing what "handle a 401" means (that's a
/// presentation/auth concern). `main.dart` (the composition root) is the only
/// place that fills this in — mirrors how `AuthInterceptor.currentToken` lets
/// a higher layer feed the network layer state without an import cycle.
class SessionExpiryNotifier {
  const SessionExpiryNotifier._();

  static VoidCallback? onUnauthorized;
}
