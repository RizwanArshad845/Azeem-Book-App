import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/network/session/session_expiry_notifier.dart';
import 'presentation/auth/viewmodel/auth_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final container = ProviderContainer();
  // Composition root: the only place allowed to wire core/network state
  // (a 401 came back) to a presentation/auth action (log the session out).
  SessionExpiryNotifier.onUnauthorized =
      () => container.read(authViewModelProvider.notifier).logout();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
