import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../domain/student_cart/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item, required this.onRemove});

  final CartItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final discountedPrice = item.discountedPrice;
    return AppListRow(
      title: item.subjectName,
      titleMaxLines: 2,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.cartItemTestCount(item.testCount),
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.dimens.xs),
          discountedPrice != null
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
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.close, color: context.colors.textSecondary),
        tooltip: context.l10n.cartRemoveTooltip,
        onPressed: onRemove,
      ),
    );
  }
}
