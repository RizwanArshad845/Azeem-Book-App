import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/splash_viewmodel.dart';
import '../widgets/splash_ambient_glow.dart';
import '../widgets/splash_animated_logo.dart';
import '../widgets/splash_golden_divider.dart';
import '../widgets/splash_pulse_dots.dart';
import '../widgets/splash_tagline.dart';
import '../widgets/splash_written_title.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.40, curve: Curves.easeOutBack),
  );

  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
  );

  late final Animation<double> _logoGlow = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.20, 0.65, curve: Curves.easeInOut),
  );

  late final Animation<double> _textProgress = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 0.75, curve: Curves.easeInOut),
  );

  late final Animation<double> _dividerScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.60, 0.85, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _taglineFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.70, 0.95, curve: Curves.easeOut),
  );

  late final Animation<double> _taglineSlide = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.70, 0.95, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _bottomDotsFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.80, 1.0, curve: Curves.easeIn),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    ref.listen(splashViewModelProvider, (previous, isReady) {
      if (isReady) context.go(AppRoutes.authRoleSelect);
    });

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primary,
              Color.lerp(colors.primary, Colors.black, 0.25)!,
              Color.lerp(colors.primary, Colors.black, 0.55)!,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Ambient subtle background radial glow behind logo
            SplashAmbientGlow(animation: _logoGlow),

            // Main Centered Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with entrance and breathing aura
                  SplashAnimatedLogo(
                    scaleAnimation: _logoScale,
                    fadeAnimation: _logoFade,
                    glowAnimation: _logoGlow,
                  ),

                  SizedBox(height: dimens.lg),

                  // Animated letter-by-letter brand name
                  SplashWrittenTitle(
                    progress: _textProgress,
                  ),

                  SizedBox(height: dimens.sm + 2),

                  // Golden Accent Divider
                  SplashGoldenDivider(
                    scaleAnimation: _dividerScale,
                  ),

                  SizedBox(height: dimens.md - 4),

                  // Tagline with slide-up and fade
                  SplashTagline(
                    fadeAnimation: _taglineFade,
                    slideAnimation: _taglineSlide,
                  ),
                ],
              ),
            ),

            // Bottom loading dots indicator
            SplashPulseDots(
              fadeAnimation: _bottomDotsFade,
            ),
          ],
        ),
      ),
    );
  }
}
