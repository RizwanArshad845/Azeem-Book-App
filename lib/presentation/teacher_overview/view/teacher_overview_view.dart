import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_actions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/delayed_loader.dart';
import '../../../core/widgets/greeting_hero_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';
import '../widgets/projected_earnings_hero_card.dart';
import '../widgets/teacher_quick_actions_grid.dart';
import '../widgets/teacher_recent_activity_section.dart';

/// Teacher shell Overview tab root (§10.2: "Students onboarded, actual +
/// projected earnings summary"). Purely a read-only summary over the current
/// teacher's state, no primary action on this screen (§10.1's
/// "one primary action per screen" rule doesn't force a button where the
/// screen's whole purpose is at-a-glance status, mirrors `TeacherEarningsView`).
class TeacherOverviewView extends ConsumerWidget {
  const TeacherOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacher = ref.watch(currentTeacherProvider);

    if (teacher == null) {
      // Not just a rare edge case in practice — the teacher lookup behind
      // `currentTeacherProvider` is a real network call that can take a
      // couple of seconds, and this is the first screen shown after login,
      // so `teacher == null` is the normal state for a moment here, not a
      // failure. Show a loader, not an empty/error state.
      return Scaffold(
        appBar: AppBar(
          title: AppBarTitle(context.l10n.teacherHomeTitle),
          actions: const [AppBarActions(role: UserRole.teacher)],
        ),
        body: const DelayedLoader(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(context.l10n.teacherHomeTitle),
        actions: const [AppBarActions(role: UserRole.teacher)],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.dimens.lg),
          children: [
            GreetingHeroCard(
              name: teacher.name,
              greeting: context.l10n.teacherOverviewWelcomeName(teacher.name),
              subtitle: context.l10n.teacherOverviewWelcomeSubtitle,
            ),
            SizedBox(height: context.dimens.xl),
            const ProjectedEarningsHeroCard(),
            SizedBox(height: context.dimens.xl),
            const TeacherQuickActionsGrid(),
            SizedBox(height: context.dimens.xl),
            const TeacherRecentActivitySection(),
          ],
        ),
      ),
    );
  }
}
