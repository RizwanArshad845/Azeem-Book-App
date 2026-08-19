import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Reusable in-card title and subtitle header for onboarding step views.
class OnboardingStepHeader extends StatelessWidget {
  const OnboardingStepHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.logo,
  });

  final String title;
  final String? subtitle;
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logo != null) ...[
          logo!,
          SizedBox(height: context.dimens.md),
        ],
        Text(
          title,
          style: context.textStyles.headlineSmall?.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          SizedBox(height: context.dimens.xs),
          Text(
            subtitle!,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
