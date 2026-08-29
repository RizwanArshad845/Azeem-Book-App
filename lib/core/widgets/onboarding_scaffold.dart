import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extensions.dart';
import '../providers/locale_provider.dart';
import 'onboarding_card.dart';
import 'section_progress_indicator.dart';

/// Standardized onboarding screen scaffold featuring an educational background pattern,
/// clean "Onboarding" app bar with step progress, language toggle, and floating card / open canvas.
class OnboardingScaffold extends ConsumerWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.currentStep,
    this.totalSteps,
    this.appBarTitle,
    this.onBack,
    this.useCardContainer = true,
    this.cardStyle,
  });

  final Widget child;
  final int? currentStep;
  final int? totalSteps;
  final String? appBarTitle;
  final VoidCallback? onBack;

  /// When false, allows the content to float on an open canvas without the outer OnboardingCard box.
  final bool useCardContainer;

  /// Specific card style to use, or automatically picks based on currentStep.
  final OnboardingCardStyle? cardStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isUrdu = currentLocale?.languageCode == 'ur';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            appBarTitle ?? context.l10n.onboardingDefaultTitle,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        leading: onBack != null
            ? IconButton(
                icon: Icon(
                  isUrdu
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                ),
                onPressed: onBack,
              )
            : null,
        actions: [
          // Language switcher button available on all onboarding stages
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(context.dimens.pillRadius),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(
                      isUrdu ? const Locale('en') : const Locale('ur'),
                    );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.sm,
                  vertical: context.dimens.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius:
                      BorderRadius.circular(context.dimens.pillRadius),
                  border: Border.all(
                    color: context.colors.divider,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      size: context.dimens.iconSm,
                      color: context.colors.primary,
                    ),
                    SizedBox(width: context.dimens.xs / 2),
                    Text(
                      context.l10n.langToggleLabel,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (currentStep != null && totalSteps != null) ...[
            SizedBox(width: context.dimens.xs),
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
                    borderRadius:
                        BorderRadius.circular(context.dimens.pillRadius),
                  ),
                  child: Text(
                    context.l10n.onboardingStepOfTotal(
                      currentStep!,
                      totalSteps!,
                    ),
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ] else
            SizedBox(width: context.dimens.md),
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
          // Soft ambient background tint + subtle study pattern
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
            'assets/images/study_bg.png',
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.20),
            colorBlendMode: BlendMode.modulate,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),

          // Content body
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.dimens.md,
                vertical: context.dimens.lg,
              ),
              child: useCardContainer
                  ? OnboardingCard(
                      style: cardStyle ?? OnboardingCardStyle.frostedGlass,
                      child: child,
                    )
                  // [NEW OPEN CANVAS OPTION]: Floats freely without outer card
                  : Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: context.dimens.contentMaxWidth,
                        ),
                        child: child,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
