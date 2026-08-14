import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/press_scale.dart';

class HomeFeatureCard extends StatelessWidget {
  const HomeFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: PressScale(
        child: Card(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(dimens.radiusLg),
            child: Padding(
              padding: EdgeInsets.all(dimens.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(dimens.radiusMd),
                    ),
                    child: Icon(icon, color: colors.primary),
                  ),
                  SizedBox(width: dimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(subtitle, style: TextStyle(color: colors.textSecondary)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
