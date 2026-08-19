import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Step progress bar for multi-step flows (onboarding, checkout).
class SectionProgressIndicator extends StatelessWidget {
  const SectionProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.dimens.xs / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.dimens.radiusSm),
                child: LinearProgressIndicator(
                  value: i <= currentStep ? 1 : 0,
                  minHeight: 4,
                  backgroundColor: context.colors.divider,
                  valueColor: AlwaysStoppedAnimation(context.colors.primary),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
