import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// A dark brand banner showing the remaining-free-attempts message plus an
/// "Upgrade" button (attempts_limit_reference). Presentational — the caller
/// supplies already-localized [message] and [upgradeLabel].
class AttemptsBanner extends StatelessWidget {
  const AttemptsBanner({
    super.key,
    required this.message,
    required this.upgradeLabel,
    this.onUpgrade,
    this.margin,
  });

  final String message;
  final String upgradeLabel;
  final VoidCallback? onUpgrade;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.md,
        vertical: context.dimens.sm + 4,
      ),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(context.dimens.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: context.textStyles.titleSmall?.copyWith(
                color: context.colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: context.dimens.sm),
          OutlinedButton(
            onPressed: onUpgrade,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.secondary,
              side: BorderSide(color: context.colors.secondary),
              padding: EdgeInsets.symmetric(
                horizontal: context.dimens.md,
                vertical: context.dimens.xs,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dimens.pillRadius),
              ),
            ),
            child: Text(upgradeLabel),
          ),
        ],
      ),
    );
  }
}
