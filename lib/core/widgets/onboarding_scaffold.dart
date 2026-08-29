import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'app_logo.dart';
import 'onboarding_card.dart';
import 'onboarding_icon_pattern_background.dart';
import 'onboarding_speech_bubble.dart';
import 'section_progress_indicator.dart';

/// Standardized onboarding screen scaffold featuring a generated branded
/// icon-pattern background, persistent logo header, clean "Onboarding" app
/// bar with step progress, and a floating glassmorphic card body (§10.1's
/// "Kiraya card" spec).
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.currentStep,
    this.totalSteps,
    this.appBarTitle = 'Onboarding',
    this.onBack,
    this.role = OnboardingRole.student,
    this.speechBubbleMessage,
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

  /// Optional decorative "speech bubble" line shown near the card. Falls
  /// back to a friendly role-specific default when not supplied.
  final String? speechBubbleMessage;

  String _defaultSpeechBubble(BuildContext context) {
    return role == OnboardingRole.student
        ? "Let's get you started!"
        : "Let's set up your classroom!";
  }

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
          // Generated branded background pattern (native icons, tiled and
          // rotated at low opacity) — replaces the old flat study_bg image.
          OnboardingIconPatternBackground(role: role),

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
                            SizedBox(height: context.dimens.sm),
                            OnboardingSpeechBubble(
                              message: speechBubbleMessage ??
                                  _defaultSpeechBubble(context),
                              icon: role == OnboardingRole.student
                                  ? Icons.menu_book_outlined
                                  : Icons.workspace_premium_outlined,
                              alignment: Alignment.center,
                            ),
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
