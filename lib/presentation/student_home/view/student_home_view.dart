import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_action_menu_sheet.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../widgets/live_test_banner.dart';
import '../widgets/student_welcome_header.dart';
import '../widgets/subject_card.dart';

/// Student shell Home tab root (§10.2: "Selected subjects grid, live-test
/// banner, subject -> chapter -> test drill-down"). Live-test banner only
/// renders when at least one live test exists for this student's enrolled
/// subjects; otherwise nothing is shown in its place (§10.1 — not a broken
/// empty banner).
class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveTestsAsync = ref.watch(liveTestsProvider);
    final subjectsAsync = ref.watch(enrolledSubjectsProvider);
    final student = ref.watch(currentStudentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeNavHome),
        actions: const [ActionMenuButton(role: UserRole.student)],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(liveTestsProvider);
            ref.invalidate(enrolledSubjectsProvider);
          },
          child: ListView(
            padding: EdgeInsets.all(context.dimens.lg),
            children: [
              if (student != null) ...[
                StudentWelcomeHeader(student: student),
                SizedBox(height: context.dimens.lg),
              ],
              LiveTestBanner(liveTestsAsync: liveTestsAsync),
              SizedBox(height: context.dimens.lg),
              Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    color: context.colors.textSecondary,
                    size: context.dimens.iconSm,
                  ),
                  SizedBox(width: context.dimens.xs),
                  Text(
                    context.l10n.subjectSelectionTitle,
                    style: context.textStyles.titleMedium,
                  ),
                ],
              ),
              SizedBox(height: context.dimens.md),
              AsyncValueWidget<List<Subject>>(
                value: subjectsAsync,
                onRetry: () => ref.invalidate(enrolledSubjectsProvider),
                data: (subjects) {
                  if (subjects.isEmpty) {
                    return EmptyStateView(
                      message: context.l10n.studentHomeNoSubjects,
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subjects.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: context.dimens.md,
                          crossAxisSpacing: context.dimens.md,
                          childAspectRatio: 0.88,
                        ),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return SubjectCard(subject: subject);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
