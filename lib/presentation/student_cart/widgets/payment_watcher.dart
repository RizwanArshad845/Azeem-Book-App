import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../viewmodel/student_cart_viewmodel.dart';

/// Wraps the student shell so a payment the student walked away from is
/// never lost track of:
/// - on app start and whenever the app returns to the foreground (e.g. back
///   from a wallet app), resumes waiting on any payment still pending
///   server-side;
/// - when one settles, tells the student wherever they are — except on
///   `CheckoutView`, which already shows the outcome itself.
class PaymentWatcher extends ConsumerStatefulWidget {
  const PaymentWatcher({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PaymentWatcher> createState() => _PaymentWatcherState();
}

class _PaymentWatcherState extends ConsumerState<PaymentWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _resume());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _resume();
  }

  void _resume() {
    if (!mounted) return;
    ref.read(paymentConfirmationProvider.notifier).resumeIfPending();
  }

  // Covers both `cartCheckout` and the gateway WebView pushed above it.
  bool get _isOnCheckout => GoRouter.of(context)
      .routerDelegate
      .currentConfiguration
      .uri
      .path
      .startsWith(AppRoutes.cartCheckout);

  @override
  Widget build(BuildContext context) {
    ref.listen<PaymentConfirmation>(paymentConfirmationProvider, (_, next) {
      if (_isOnCheckout) return;
      final message = switch (next) {
        PaymentConfirmation.confirmed => context.l10n.paymentConfirmedMessage,
        PaymentConfirmation.failed => context.l10n.paymentFailedMessage,
        _ => null,
      };
      if (message != null) AppSnackbar.show(context, message);
    });
    return widget.child;
  }
}
