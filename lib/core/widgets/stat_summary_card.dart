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
    this.useGradientIconBadge = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? subtitle;
  final TextStyle? valueStyle;
  final bool trailingValue;
  final bool wrapInCard;

  /// When true (and [icon] is set), renders the icon inside a small
  /// gradient-filled rounded badge (derived from [iconColor]/`primary` ->
  /// `secondary`, never an arbitrary hex value) instead of a flat single
  /// color icon — CLAUDE.md's "gradient accent badge" ask for dashboard
  /// stat rows. Defaults to false so every existing call site (which just
  /// wants the plain icon) is unaffected.
  final bool useGradientIconBadge;

  @override
  Widget build(BuildContext context) {
    final content = trailingValue ? _trailingLayout(context) : _iconLayout(context);
    return wrapInCard ? AppCard(child: content) : content;
  }

  Widget _iconLayout(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          _IconBadge(
            icon: icon!,
            iconColor: iconColor,
            useGradient: useGradientIconBadge,
          ),
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

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.iconColor,
    required this.useGradient,
  });

  final IconData icon;
  final Color? iconColor;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    if (!useGradient) {
      return Icon(icon, color: iconColor ?? context.colors.primary);
    }

    final start = iconColor ?? context.colors.primary;
    return Container(
      padding: EdgeInsets.all(context.dimens.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start, context.colors.secondary],
        ),
        borderRadius: BorderRadius.circular(context.dimens.radiusMd),
      ),
      child: Icon(icon, color: context.colors.onPrimary, size: context.dimens.iconMd),
    );
  }
}
