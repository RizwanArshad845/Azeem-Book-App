import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'floating_glass_nav_bar.dart';

/// One destination in a role's persistent bottom nav bar (§10.2).
class BottomNavDestinationSpec {
  const BottomNavDestinationSpec({required this.icon, required this.label});

  final IconData icon;
  final String label;
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
      body: navigationShell,
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
