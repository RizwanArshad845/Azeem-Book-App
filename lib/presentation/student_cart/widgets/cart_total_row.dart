import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class CartTotalRow extends StatelessWidget {
  const CartTotalRow({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(context.l10n.cartTotal, style: context.textStyles.titleMedium),
        Text(
          'Rs. ${total.toStringAsFixed(0)}',
          style: context.textStyles.titleMedium?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
