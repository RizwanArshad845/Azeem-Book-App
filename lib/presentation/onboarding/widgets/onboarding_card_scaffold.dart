import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/fade_slide_in.dart';

/// Standard layout widget for onboarding screens:
/// Places a floating white card over the Azeem brand study background pattern,
/// featuring a top back button, header icon, title, subtitle, and automatic tap-to-unfocus.
class OnboardingCardScaffold extends StatelessWidget {
  const OnboardingCardScaffold({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = true,
    this.onBackTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Study Illustration
            Image.asset(
              AppAssets.studyBg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [colors.primary.withValues(alpha: 0.85), colors.primary],
                  ),
                ),
              ),
            ),

            // Background Scrim Mask
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ),

            // Optional Top Back Button
            if (showBackButton)
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(dimens.sm),
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(dimens.sm),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
                      ),
                      onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
              ),

            // Centered White Floating Card
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: dimens.lg, vertical: dimens.md),
                  child: FadeSlideIn(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: dimens.contentMaxWidth),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(dimens.radiusXl),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: dimens.lg, vertical: dimens.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Brand Icon Header
                          Container(
                            width: dimens.avatarLg,
                            height: dimens.avatarLg,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(dimens.radiusLg),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              icon,
                              size: dimens.iconLg,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(height: dimens.lg),

                          // Title
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: dimens.sm),

                          // Subtitle
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textSecondary,
                              height: 1.35,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: dimens.xl),

                          // Form Content Child
                          child,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
