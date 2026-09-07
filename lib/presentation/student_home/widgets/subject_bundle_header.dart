import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';

/// Promotional header displayed above the chapter list when a subject
/// has not yet been purchased, offering a one-tap full bundle checkout.
class SubjectBundleHeader extends StatelessWidget {
  const SubjectBundleHeader({
    super.key,
    required this.subjectName,
    required this.price,
    required this.onBuyNow,
    this.originalPrice,
    this.discountPercent,
    this.loading = false,
  });

  final String subjectName;

  /// Null hides the price/discount row and falls back to a plain "Buy Now"
  /// button label — used pre-first-attempt per the pricing-visibility rule.
  /// The amount the student actually pays (`Subject.discountedPrice` when
  /// present, otherwise `Subject.bundlePrice`).
  final String? price;

  /// The pre-discount `Subject.bundlePrice`, shown struck through next to
  /// [price] — only when it differs from [price] (i.e. a discount actually
  /// applies for this student). Null hides the strike-through row and the
  /// discount badge.
  final String? originalPrice;
  final VoidCallback onBuyNow;

  /// Shown as a "N% OFF" badge only when [originalPrice] is non-null.
  final int? discountPercent;

  /// True while the cart mutation this button triggered is in flight —
  /// disables the button and shows its built-in spinner instead of letting
  /// a double-tap fire a second `addSubjectBundle` call.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final localizedName = context.l10n.localizedSubjectName(subjectName);
    final bundleTitle = context.l10n.subjectBundleTitle(localizedName);
    final discountLabel = discountPercent != null
        ? context.l10n.subjectBundleDiscount(discountPercent!)
        : null;
    final priceLabel = price != null ? context.l10n.subjectCardAddToCart(price!) : null;
    final originalPriceLabel = originalPrice != null
        ? context.l10n.subjectCardAddToCart(originalPrice!)
        : null;
    final buttonLabel =
        price != null ? context.l10n.buyNowWithPrice(price!) : context.l10n.buyNow;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.dimens.sm),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                ),
                child: Icon(
                  subjectIcon(subjectName),
                  color: context.colors.primary,
                  size: context.dimens.iconMd,
                ),
              ),
              SizedBox(width: context.dimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bundleTitle,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (priceLabel != null) ...[
                      SizedBox(height: context.dimens.xs / 2),
                      Row(
                        children: [
                          if (originalPriceLabel != null) ...[
                            Text(
                              originalPriceLabel,
                              style: context.textStyles.bodyMedium?.copyWith(
                                color: context.colors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: context.dimens.sm),
                          ],
                          Text(
                            priceLabel,
                            style: context.textStyles.titleSmall?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (discountLabel != null) ...[
                            SizedBox(width: context.dimens.sm),
                            StatusBadge(
                              label: discountLabel,
                              color: context.colors.secondary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),
          AppPrimaryButton(
            label: buttonLabel,
            icon: Icons.shopping_bag_outlined,
            loading: loading,
            onPressed: onBuyNow,
          ),
        ],
      ),
    );
  }
}
