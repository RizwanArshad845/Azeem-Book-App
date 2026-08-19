import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/stat_summary_card.dart';
import '../viewmodel/teacher_overview_viewmodel.dart';
import '../widgets/teacher_earnings_card.dart';
import '../widgets/welcome_header.dart';

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
      // Edge case only — router redirect guarantees a resolved teacher
      // before the shell is reachable. Guarded here so this view never
      // crashes if that invariant is ever violated.
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.teacherOverviewTitle)),
        body: EmptyStateView(
          message: context.l10n.teacherProfileUnavailable,
          icon: Icons.person_off_outlined,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.teacherOverviewTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.dimens.lg),
          children: [
            WelcomeHeader(teacher: teacher),
            SizedBox(height: context.dimens.xl),
            StatSummaryCard(
              icon: Icons.groups_outlined,
              label: context.l10n.teacherOverviewStudents,
              value: teacher.declaredStudentCount != null
                  ? '${teacher.declaredStudentCount}'
                  : context.l10n.teacherOverviewNotSetYet,
            ),
            SizedBox(height: context.dimens.md),
            TeacherEarningsCard(teacher: teacher),
          ],
        ),
      ),
    );
  }
}
