import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_card.dart';

/// Grid card shell shared by Student Home's subject cards and the Subject
/// Hub's action cards (Video Lectures / Online Test / Ebook): a leading
/// visual with an optional top-right badge, a bold title, and a one-line
/// hint with a chevron. Callers supply the visual so each card can size its
/// own art (thumbnail, YouTube badge, icon tile).
class HubActionCard extends StatelessWidget {
  const HubActionCard({
    super.key,
    required this.leading,
    required this.title,
    required this.hint,
    this.badge,
    this.onTap,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final String hint;
  final Widget? badge;
  final VoidCallback? onTap;

  /// Replaces the hint row's chevron, e.g. a progress spinner.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              ?badge,
            ],
          ),
          SizedBox(height: context.dimens.xs),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: context.dimens.xs / 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: context.colors.textSecondary,
                    size: context.dimens.iconSm,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
