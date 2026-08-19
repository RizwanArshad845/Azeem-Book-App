import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../domain/student_cart/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.title,
    required this.onRemove,
  });

  final CartItem item;
  final String title;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final discountedPrice = item.discountedPrice;
    return AppListRow(
      title: title,
      titleMaxLines: 2,
      subtitle: discountedPrice != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rs. ${item.price.toStringAsFixed(0)}',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: context.dimens.sm),
                Text(
                  'Rs. ${discountedPrice.toStringAsFixed(0)}',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              'Rs. ${item.price.toStringAsFixed(0)}',
              style: context.textStyles.bodyMedium,
            ),
      trailing: IconButton(
        icon: Icon(Icons.close, color: context.colors.textSecondary),
        tooltip: context.l10n.cartRemoveTooltip,
        onPressed: onRemove,
      ),
    );
  }
}
