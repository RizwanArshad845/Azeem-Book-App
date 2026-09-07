import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../widgets/splash_ambient_glow.dart';
import '../widgets/splash_animated_logo.dart';
import '../widgets/splash_pulse_dots.dart';


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

    // Navigation is owned entirely by the GoRouter redirect in app_router.dart.
    // When splashViewModelProvider emits `true`, _RouterRefreshNotifier fires
    // GoRouter.refresh() which re-runs _redirectFor and routes to the correct
    // first screen based on session + onboarding state — no hardcoded
    // destination here.


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
              child: SplashAnimatedLogo(
                scaleAnimation: _logoScale,
                fadeAnimation: _logoFade,
                glowAnimation: _logoGlow,
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
