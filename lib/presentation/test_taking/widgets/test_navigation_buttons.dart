import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';

class TestNavigationButtons extends StatelessWidget {
  const TestNavigationButtons({
    super.key,
    required this.showPrevious,
    required this.isLastQuestion,
    required this.isSubmitting,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  });

  final bool showPrevious;
  final bool isLastQuestion;
  final bool isSubmitting;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showPrevious) ...[
          Expanded(
            child: AppOutlinedButton(
              label: context.l10n.testPreviousButton,
              onPressed: isSubmitting ? null : onPrevious,
            ),
          ),
          SizedBox(width: context.dimens.md),
        ],
        Expanded(
          child: isLastQuestion
              ? AppPrimaryButton(
                  label: context.l10n.testSubmitButton,
                  loading: isSubmitting,
                  onPressed: isSubmitting ? null : onSubmit,
                )
              : AppPrimaryButton(
                  label: context.l10n.testNextButton,
                  onPressed: isSubmitting ? null : onNext,
                ),
        ),
      ],
    );
  }
}
