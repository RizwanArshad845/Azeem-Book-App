import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../domain/student_cart/entities/cart_item.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';
import '../viewmodel/student_cart_viewmodel.dart';

class CartItemCard extends ConsumerWidget {
  const CartItemCard({super.key, required this.item, required this.onRemove});

  final CartItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discountedPrice = item.discountedPrice;
    final resolvedSubject =
        (item.subjectName == null || item.subjectName!.isEmpty)
            ? ref.watch(subjectByIdProvider(item.subjectId)).value
            : null;
    final resolvedTests = item.testCount == null
        ? ref.watch(testsForSubjectProvider(item.subjectId)).value
        : null;
    final testCount = item.testCount ?? resolvedTests?.length;

    final rawName = (item.subjectName != null && item.subjectName!.isNotEmpty)
        ? item.subjectName!
        : (resolvedSubject?.name ?? item.subjectId);
    final displayName = context.l10n.localizedSubjectName(rawName);

    return AppListRow(
      title: displayName,
      titleMaxLines: 2,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (testCount != null) ...[
            Text(
              context.l10n.cartItemTestCount(testCount),
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimens.xs),
          ],
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
