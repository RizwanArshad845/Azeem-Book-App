import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'onboarding_card.dart';
import 'section_progress_indicator.dart';

/// Standardized onboarding screen scaffold featuring an educational background pattern,
/// clean "Onboarding" app bar with step progress, and floating card body.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.currentStep,
    this.totalSteps,
    this.appBarTitle = 'Onboarding',
    this.onBack,
  });

  final Widget child;
  final int? currentStep;
  final int? totalSteps;
  final String appBarTitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              )
            : null,
        actions: [
          if (currentStep != null && totalSteps != null)
            Padding(
              padding: EdgeInsets.only(right: context.dimens.md),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.sm,
                    vertical: context.dimens.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.dimens.pillRadius),
                  ),
                  child: Text(
                    'Step $currentStep of $totalSteps',
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
        bottom: (currentStep != null && totalSteps != null)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(6.0),
                child: SectionProgressIndicator(
                  currentStep: currentStep!,
                  totalSteps: totalSteps!,
                ),
              )
            : null,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background study pattern image
          Opacity(
            opacity: 0.25,
            child: Image.asset(
              'assets/images/study_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),

          // Floating content card
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.dimens.md,
                vertical: context.dimens.lg,
              ),
              child: OnboardingCard(child: child),
            ),
          ),
        ],
      ),
    );
  }
}
