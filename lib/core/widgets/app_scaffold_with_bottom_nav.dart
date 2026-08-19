import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One destination in a role's persistent bottom nav bar (§10.2).
class BottomNavDestinationSpec {
  const BottomNavDestinationSpec({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Shell scaffold for `StatefulShellRoute.indexedStack` — persistent bottom
/// nav bar, each tab preserving its own scroll/state (§10.2). The set of
/// [destinations] is the only thing that differs between the Student and
/// Teacher shells; the scaffold shape itself never changes.
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
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}
