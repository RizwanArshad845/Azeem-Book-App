import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/cart_item.dart';
import '../viewmodel/student_cart_viewmodel.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_total_row.dart';
import '../widgets/checkout_review_sheet.dart';
import '../widgets/payment_processing_banner.dart';

/// Student shell Cart tab root (§10.2: "Add-to-cart summary, checkout ->
/// payment gateway redirect"). One primary action per §10.1: the
/// "Checkout" `AppPrimaryButton`; removing a line item is a de-emphasized icon
/// action on each card, not a competing primary action.
class StudentCartView extends ConsumerWidget {
  const StudentCartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(studentCartViewModelProvider);
    final isMutating = ref.watch(cartMutationInProgressProvider);
    final hasPendingPayment = ref.watch(
      pendingSubjectIdsProvider.select((ids) => ids.value?.isNotEmpty ?? false),
    );

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.cartTitle)),
      body: SafeArea(
        child: Column(
          children: [
            // A payment the student left mid-way: its items are reserved
            // (so not listed below) until the gateway reports back.
            if (hasPendingPayment)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.dimens.lg,
                  context.dimens.lg,
                  context.dimens.lg,
                  0,
                ),
                child: const PaymentProcessingBanner(),
              ),
            Expanded(child: _buildCart(context, ref, cartAsync, isMutating)),
          ],
        ),
      ),
    );
  }

  Widget _buildCart(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Cart> cartAsync,
    bool isMutating,
  ) {
    return AsyncValueWidget<Cart>(
          value: cartAsync,
          onRetry: () => ref.invalidate(studentCartViewModelProvider),
          skeleton: Padding(
            padding: EdgeInsets.all(context.dimens.lg),
            child: const SkeletonList(itemCount: 3, itemHeight: 76),
          ),
          data: (cart) {
            final items = cart.items ?? const <CartItem>[];
            if (items.isEmpty) {
              return EmptyStateView(
                icon: Icons.shopping_cart_outlined,
                message: context.l10n.cartEmpty,
              );
            }

            return Padding(
              padding: EdgeInsets.all(context.dimens.lg),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: context.dimens.sm),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return CartItemCard(
                          item: item,
                          removing: isMutating,
                          onRemove: () => ref
                              .read(studentCartViewModelProvider.notifier)
                              .removeSubject(item.subjectId),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.dimens.md),
                  CartTotalRow(total: cart.totalAmount),
                  SizedBox(height: context.dimens.lg),
                  AppPrimaryButton(
                    label: context.l10n.cartCheckout,
                    onPressed: () => CheckoutReviewSheet.show(context),
                  ),
                ],
              ),
            );
          },
        );
  }
}
