import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/cart_item.dart';
import '../viewmodel/student_cart_viewmodel.dart';
import 'cart_item_card.dart';
import 'cart_total_row.dart';

/// Order-review step between Cart's "Proceed to Checkout" and the actual
/// (simulated) payment redirect — lists the purchased items + total with an
/// explicit "Pay" button, so Checkout is no longer a screen with nothing to
/// review that auto-triggers payment the instant it opens.
class CheckoutReviewSheet extends ConsumerWidget {
  const CheckoutReviewSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.checkoutTitle,
      child: const CheckoutReviewSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(studentCartViewModelProvider);

    return AsyncValueWidget<Cart>(
      value: cartAsync,
      onRetry: () => ref.invalidate(studentCartViewModelProvider),
      skeleton: const SkeletonList(itemCount: 2, itemHeight: 76),
      data: (cart) {
        final items = cart.items ?? const <CartItem>[];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in items)
              Padding(
                padding: EdgeInsets.only(bottom: context.dimens.sm),
                child: CartItemCard(
                  item: item,
                  onRemove: () => ref
                      .read(studentCartViewModelProvider.notifier)
                      .removeSubject(item.subjectId),
                ),
              ),
            SizedBox(height: context.dimens.sm),
            CartTotalRow(total: cart.totalAmount),
            SizedBox(height: context.dimens.lg),
            AppPrimaryButton(
              label: context.l10n.checkoutPayNow,
              icon: Icons.lock_outline,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.cartCheckout);
              },
            ),
          ],
        );
      },
    );
  }
}
