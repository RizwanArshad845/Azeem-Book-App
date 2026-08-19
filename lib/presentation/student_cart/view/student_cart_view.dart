import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/cart_item.dart';
import '../viewmodel/student_cart_viewmodel.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_total_row.dart';

/// Student shell Cart tab root (§10.2: "Add-to-cart summary, checkout ->
/// payment gateway redirect"). One primary action per §10.1: the
/// "Checkout" `AppPrimaryButton`; removing a line item is a de-emphasized icon
/// action on each card, not a competing primary action.
class StudentCartView extends ConsumerWidget {
  const StudentCartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(studentCartViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cartTitle)),
      body: SafeArea(
        child: AsyncValueWidget<Cart>(
          value: cartAsync,
          onRetry: () => ref.invalidate(studentCartViewModelProvider),
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
                    onPressed: () => context.push(AppRoutes.cartCheckout),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
