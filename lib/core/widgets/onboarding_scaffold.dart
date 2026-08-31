import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../extensions/context_extensions.dart';
import 'app_language_toggle_button.dart';
import 'app_logo.dart';
import 'onboarding_card.dart';
import 'section_progress_indicator.dart';

/// Which onboarding flow is currently rendering.
enum OnboardingRole { student, teacher }

/// Standardized onboarding screen scaffold featuring rameel-branch's
/// branded doodle-pattern background image, persistent logo header, clean
/// "Onboarding" app bar with step progress, and a floating glassmorphic
/// card body (§10.1's "Kiraya card" spec).
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.currentStep,
    this.totalSteps,
    this.appBarTitle = 'Onboarding',
    this.onBack,
    this.role = OnboardingRole.student,
  });

  final Widget child;
  final int? currentStep;
  final int? totalSteps;
  final String appBarTitle;
  final VoidCallback? onBack;

  /// Which onboarding flow this is — switches the generated icon pattern
  /// vocabulary so student vs teacher onboarding don't feel like palette
  /// swaps of each other.
  final OnboardingRole role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: onBack != null
            ? IconButton(
                icon: Icon(Icons.adaptive.arrow_back),
                onPressed: onBack,
              )
            : null,
        actions: [
          const AppLanguageToggleButton(),
          if (currentStep != null && totalSteps != null)
            Padding(
              padding: EdgeInsets.only(right: context.dimens.sm),
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
          // Soft ambient background tint + rameel-branch's doodle study
          // pattern image (books, grad caps, pencils, math/science symbols),
          // shared identically by both roles.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colors.background,
                  context.colors.surfaceVariant.withValues(alpha: 0.25),
                ],
              ),
            ),
          ),
          Image.asset(
            AppAssets.studyBg,
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.20),
            colorBlendMode: BlendMode.modulate,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),

          // Persistent logo header + floating glassmorphic content card.
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final verticalPadding = context.dimens.lg * 2;
                final minHeight = constraints.maxHeight > verticalPadding
                    ? constraints.maxHeight - verticalPadding
                    : 0.0;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.md,
                    vertical: context.dimens.lg,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minHeight,
                    ),
                    child: Center(
                      child: OnboardingCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _LogoHeader(),
                            SizedBox(height: context.dimens.md),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Small, ambient-glow logo — a scaled-down version of the splash screen's
/// treatment so the brand reads as one continuous thread from Splash →
/// Role Select → Onboarding.
class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.28),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const AppLogo(size: 60),
    );
  }
}
