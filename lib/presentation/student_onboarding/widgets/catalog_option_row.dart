import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';

/// Selectable row for a single Admin-managed catalog option (a [ClassLevel]
/// or a [BoardClass] leaf) — generalized from the old `BoardClassRow` so
/// `StudentAcademicInfoView`'s Class list and Group picker share one widget
/// instead of each inventing its own near-identical row (see this project's
/// shared-widget-reuse convention). Disabled options render visibly but
/// unselectable ("coming soon"), per §9.1/§9.2.
class CatalogOptionRow extends StatelessWidget {
  const CatalogOptionRow({
    super.key,
    required this.label,
    required this.isEnabled,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isEnabled;
  final bool isSelected;
  final VoidCallback? onTap;

  /// Distinct native icon for this option (class/stream chip) — CLAUDE.md
  /// mandates native Flutter icons over text-only rows.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: context.dimens.iconMd,
              color: isEnabled ? context.colors.primary : context.colors.textSecondary,
            ),
            SizedBox(width: context.dimens.sm),
          ],
          Expanded(
            child: Text(
              label,
              style: context.textStyles.bodyLarge?.copyWith(
                color: isEnabled ? null : context.colors.textSecondary,
              ),
            ),
          ),
          if (!isEnabled)
            StatusBadge(
              label: context.l10n.commonComingSoon,
              color: context.colors.warning,
            )
          else if (isSelected)
            Icon(Icons.check_circle, color: context.colors.primary),
        ],
      ),
    );
  }
}
