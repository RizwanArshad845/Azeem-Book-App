import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../viewmodel/student_cart_viewmodel.dart';

/// `AppRoutes.cartCheckout` — outside-shell, pushed on top of the student
/// shell (§10.2 "checkout -> payment gateway redirect"). Runs the
/// (simulated) checkout once on entry, then renders a single result state:
/// a "redirecting..." loading state, a success confirmation, or a failure
/// state — each with exactly one primary action (§10.1).
class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutAsync = ref.watch(checkoutPaymentProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.checkoutTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Center(
            child: AsyncValueWidget<Payment?>(
              value: checkoutAsync,
              onRetry: () => ref.invalidate(checkoutPaymentProvider),
              data: (payment) => _buildResult(context, payment, ref),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, Payment? payment, WidgetRef ref) {
    if (payment == null || payment.status == PaymentStatus.failed) {
      return AppErrorView(
        message: context.l10n.checkoutFailedMessage,
        onRetry: () => ref.invalidate(checkoutPaymentProvider),
      );
    }

    final isSuccess = payment.status == PaymentStatus.success;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSuccess ? Icons.check_circle_outline : Icons.hourglass_top_outlined,
          size: context.dimens.iconLg * 1.5,
          color: isSuccess ? context.colors.success : context.colors.warning,
        ),
        SizedBox(height: context.dimens.md),
        Text(
          isSuccess ? context.l10n.checkoutSuccessStatus : context.l10n.checkoutPendingStatus,
          style: context.textStyles.titleMedium,
        ),
        SizedBox(height: context.dimens.sm),
        Text(
          'Rs. ${payment.amount.toStringAsFixed(0)}',
          style: context.textStyles.titleLarge?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
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
}
