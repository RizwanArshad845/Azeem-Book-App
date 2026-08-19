import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/board_class.dart';

class BoardClassRow extends StatelessWidget {
  const BoardClassRow({
    super.key,
    required this.boardClass,
    required this.isSelected,
    required this.onTap,
  });

  final BoardClass boardClass;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = boardClass.isEnabled;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              boardClass.name,
              style: context.textStyles.bodyLarge?.copyWith(
                color: isEnabled ? null : context.colors.textSecondary,
              ),
            ),
          ),
          if (!isEnabled)
            StatusBadge(label: context.l10n.commonComingSoon, color: context.colors.warning)
          else if (isSelected)
            Icon(Icons.check_circle, color: context.colors.primary),
        ],
      ),
    );
  }
}
