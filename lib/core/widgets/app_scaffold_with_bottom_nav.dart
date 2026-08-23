import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'floating_glass_nav_bar.dart';

/// One destination in a role's persistent bottom nav bar (§10.2).
class BottomNavDestinationSpec {
  const BottomNavDestinationSpec({
    required this.icon,
    required this.label,
    this.badgeCount,
  });

  final IconData icon;
  final String label;

  /// Optional small animated count badge rendered on top of [icon] (e.g. the
  /// student Cart tab's item count). `null` or `0` renders no badge.
  final int? badgeCount;

  BottomNavDestinationSpec copyWith({int? badgeCount}) {
    return BottomNavDestinationSpec(
      icon: icon,
      label: label,
      badgeCount: badgeCount,
    );
  }
}

/// Shell scaffold for `StatefulShellRoute.indexedStack` — persistent floating glass
/// bottom nav bar, each tab preserving its own scroll/state (§10.2).
class AppScaffoldWithBottomNav extends StatelessWidget {
  const AppScaffoldWithBottomNav({
    super.key,
    required this.navigationShell,
    required this.destinations,
  });

  final StatefulNavigationShell navigationShell;
  final List<BottomNavDestinationSpec> destinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _BranchCrossfade(
        index: navigationShell.currentIndex,
        child: navigationShell,
      ),
      bottomNavigationBar: FloatingGlassNavBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: destinations,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

/// Quick crossfade on bottom-nav tab switches (Workstream 7 — motion
/// polish). `StatefulShellRoute.indexedStack` swaps branches via a plain
/// `IndexedStack`, which has no built-in transition and just jumps. Wrapping
/// the *whole* `navigationShell` in a single `FadeTransition` — rather than
/// keying an `AnimatedSwitcher` per branch, which would dispose/rebuild the
/// branch and defeat `indexedStack`'s whole point of preserving each tab's
/// state — fades the already-swapped content in without fighting that
/// behavior.
class _BranchCrossfade extends StatefulWidget {
  const _BranchCrossfade({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_BranchCrossfade> createState() => _BranchCrossfadeState();
}

class _BranchCrossfadeState extends State<_BranchCrossfade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
    value: 1,
  );

  @override
  void didUpdateWidget(covariant _BranchCrossfade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: widget.child,
    );
  }
}
