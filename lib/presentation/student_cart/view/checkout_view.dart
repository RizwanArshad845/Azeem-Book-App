import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../viewmodel/student_cart_viewmodel.dart';

/// `AppRoutes.cartCheckout` — outside-shell, pushed on top of the student
/// shell (§10.2 "checkout -> payment gateway redirect"). Starts the checkout
/// once on entry; a `pending` payment opens RapidGateway's hosted page
/// (`PaymentGatewayView`), and on return waits for the webhook-settled
/// purchase via `paymentConfirmationProvider`. Each state has exactly one
/// primary action (§10.1).
class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  /// Payment id whose gateway page was already auto-opened, so a rebuild
  /// never re-opens it (ephemeral navigation guard, not business state).
  String? _autoOpenedPaymentId;

  @override
  void initState() {
    super.initState();
    // `checkoutPaymentProvider` is a plain (non-autoDispose) provider so a
    // real payment call is never unintentionally re-run by widget-tree
    // churn — this explicit invalidate-on-mount is what guarantees each
    // fresh visit to this screen starts its own checkout instead of
    // replaying a previous session's cached `Payment`. Must run
    // synchronously here, before `build()`'s first `ref.watch` below —
    // deferring it (e.g. to a microtask) would let that first watch create
    // and start the provider, and the later invalidate would then discard
    // that in-flight call and fire checkout() a second time.
    ref.invalidate(checkoutPaymentProvider);
  }

  Future<void> _openGateway(Payment payment) async {
    _autoOpenedPaymentId = payment.id;
    final result = await context.push<String>(
      AppRoutes.paymentGateway,
      extra: payment.checkoutUrl,
    );
    if (!mounted) return;
    // `result` (success/failure) comes from the return URL and can't be
    // trusted, so either way the outcome is read from the server. `null` =
    // closed without reaching the return page: stay on "Pay Now".
    if (result != null) {
      ref.read(paymentConfirmationProvider.notifier).confirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutAsync = ref.watch(checkoutPaymentProvider);

    ref.listen<AsyncValue<Payment?>>(checkoutPaymentProvider, (_, next) {
      final payment = next.value;
      if (payment != null &&
          payment.status == PaymentStatus.pending &&
          payment.checkoutUrl != null &&
          payment.id != _autoOpenedPaymentId) {
        _openGateway(payment);
      }
    });

    // Leaving is always allowed, even mid-payment: if the payment is still
    // open, keep checking on it in the background (`PaymentWatcher` shows
    // the outcome wherever the student is by then).
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        final payment = checkoutAsync.value;
        if (didPop &&
            payment?.status == PaymentStatus.pending &&
            ref.read(paymentConfirmationProvider) == PaymentConfirmation.idle) {
          ref.read(paymentConfirmationProvider.notifier).resumeIfPending();
        }
      },
      child: _buildScaffold(context, checkoutAsync),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    AsyncValue<Payment?> checkoutAsync,
  ) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.checkoutTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Center(
            child: AsyncValueWidget<Payment?>(
              value: checkoutAsync,
              onRetry: () => ref.invalidate(checkoutPaymentProvider),
              data: (payment) => _buildResult(context, payment),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, Payment? payment) {
    if (payment == null || payment.status == PaymentStatus.failed) {
      return AppErrorView(
        message: context.l10n.checkoutFailedMessage,
        onRetry: () => ref.invalidate(checkoutPaymentProvider),
      );
    }
    if (payment.status == PaymentStatus.success) {
      return _buildSuccess(context, payment);
    }

    final confirmation = ref.read(paymentConfirmationProvider.notifier);
    return switch (ref.watch(paymentConfirmationProvider)) {
      PaymentConfirmation.confirmed => _buildSuccess(context, payment),
      PaymentConfirmation.confirming => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoadingIndicator(),
          SizedBox(height: context.dimens.md),
          Text(
            context.l10n.checkoutConfirming,
            style: context.textStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      PaymentConfirmation.failed => AppErrorView(
        message: context.l10n.checkoutGatewayFailedMessage,
        onRetry: () => ref.invalidate(checkoutPaymentProvider),
      ),
      PaymentConfirmation.unconfirmed => _buildPending(
        context,
        payment,
        message: context.l10n.checkoutUnconfirmedMessage,
        primaryLabel: context.l10n.commonDone,
        onPrimary: () => context.pop(),
        onCheckStatus: confirmation.confirm,
      ),
      PaymentConfirmation.idle => _buildPending(
        context,
        payment,
        message: context.l10n.checkoutGatewayHint,
        primaryLabel: context.l10n.checkoutPayNow,
        onPrimary: payment.checkoutUrl == null
            ? null
            : () => _openGateway(payment),
        onCheckStatus: confirmation.confirm,
      ),
    };
  }

  Widget _buildPending(
    BuildContext context,
    Payment payment, {
    required String message,
    required String primaryLabel,
    required VoidCallback? onPrimary,
    required VoidCallback onCheckStatus,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.hourglass_top_outlined,
          size: context.dimens.iconLg * 1.5,
          color: context.colors.warning,
        ),
        SizedBox(height: context.dimens.md),
        Text(
          context.l10n.checkoutPendingStatus,
          style: context.textStyles.titleMedium,
        ),
        SizedBox(height: context.dimens.sm),
        _amount(context, payment),
        SizedBox(height: context.dimens.sm),
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(label: primaryLabel, onPressed: onPrimary),
        SizedBox(height: context.dimens.sm),
        TextButton(
          onPressed: onCheckStatus,
          child: Text(context.l10n.checkoutCheckStatus),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context, Payment payment) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: context.dimens.iconLg * 1.5,
          color: context.colors.success,
        ),
        SizedBox(height: context.dimens.md),
        Text(
          context.l10n.checkoutSuccessStatus,
          style: context.textStyles.titleMedium,
        ),
        SizedBox(height: context.dimens.sm),
        _amount(context, payment),
        if (payment.gatewayReference != null) ...[
          SizedBox(height: context.dimens.xs),
          Text(
            'Ref: ${payment.gatewayReference}',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
        SizedBox(height: context.dimens.xl),
        AppPrimaryButton(
          label: context.l10n.commonDone,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _amount(BuildContext context, Payment payment) => Text(
    'Rs. ${payment.amount.toStringAsFixed(0)}',
    style: context.textStyles.titleLarge?.copyWith(
      color: context.colors.primary,
      fontWeight: FontWeight.w700,
    ),
  );
}
