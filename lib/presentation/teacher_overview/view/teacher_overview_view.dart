import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';
import '../widgets/projected_earnings_hero_card.dart';
import '../widgets/teacher_quick_actions_grid.dart';
import '../widgets/teacher_recent_activity_section.dart';
import '../widgets/teacher_top_bar.dart';

/// Redesigned Teacher Overview screen featuring a personalized top header,
/// motivating hero earnings & goal card, quick action tiles, and live activity stream.
class TeacherOverviewView extends ConsumerWidget {
  const TeacherOverviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacher = ref.watch(currentTeacherProvider);
    final stats = ref.watch(teacherOverviewStatsProvider);

    if (teacher == null) {
      return Scaffold(
        body: SafeArea(
          child: EmptyStateView(
            message: context.l10n.teacherProfileUnavailable,
            icon: Icons.person_off_outlined,
          ),
        ),
      );
    }

    return Scaffold(
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.lg,
              vertical: context.dimens.md,
            ),
            children: [
              // 1. Personalized Top Utility Header
              TeacherTopBar(teacher: teacher),
              SizedBox(height: context.dimens.lg),

              // 2. High-Converting Projected Earnings & Goal Progress Card
              ProjectedEarningsHeroCard(stats: stats),
              SizedBox(height: context.dimens.xl),

              // 3. Quick Actions Interactive Grid
              TeacherQuickActionsGrid(stats: stats),
              SizedBox(height: context.dimens.xl),

              // 4. Real-time Recent Activity Stream
              const TeacherRecentActivitySection(),
              SizedBox(height: context.dimens.xl),
            ],
          ),
        ),
      ),
    );
  }
}
