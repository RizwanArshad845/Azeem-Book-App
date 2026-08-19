import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// Shared icon/label/value summary row for dashboard-style tabs (Overview,
/// Earnings, per-student progress). Set [trailingValue] for the
/// label-left/value-right layout instead of the default icon-left/value-below
/// layout. Set [wrapInCard] to false to compose several rows inside one
/// shared `AppCard` (e.g. separated by a `Divider`).
class StatSummaryCard extends StatelessWidget {
  const StatSummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.subtitle,
    this.valueStyle,
    this.trailingValue = false,
    this.wrapInCard = true,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? subtitle;
  final TextStyle? valueStyle;
  final bool trailingValue;
  final bool wrapInCard;

  @override
  Widget build(BuildContext context) {
    final content = trailingValue ? _trailingLayout(context) : _iconLayout(context);
    return wrapInCard ? AppCard(child: content) : content;
  }

  Widget _iconLayout(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor ?? context.colors.primary),
          SizedBox(width: context.dimens.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: context.dimens.xs / 2),
              Text(value, style: valueStyle ?? context.textStyles.titleLarge),
              if (subtitle != null) ...[
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  subtitle!,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _trailingLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  subtitle!,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              context.textStyles.headlineSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
