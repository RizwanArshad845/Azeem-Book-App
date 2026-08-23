import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../viewmodel/teacher_students_viewmodel.dart';
import '../widgets/students_filter_bar.dart';
import '../widgets/students_list.dart';
import '../widgets/students_summary_strip.dart';

/// Redesigned Teacher Students directory tab with stat counters,
/// live search, sorting, campus filter chips, and pagination.
class TeacherStudentsView extends ConsumerWidget {
  const TeacherStudentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(teacherStudentsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          context.l10n.teacherStudentsTitle,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(teacherStudentsProvider);
              ref.invalidate(teacherStudentsSubjectsByIdProvider);
              ref.invalidate(teacherStudentsCampusesByIdProvider);
            },
            child: AsyncValueWidget<List<Student>>(
              value: studentsAsync,
              onRetry: () => ref.invalidate(teacherStudentsProvider),
              data: (students) {
                if (students.isEmpty) {
                  return ListView(
                    padding: EdgeInsets.all(context.dimens.lg),
                    children: [
                      EmptyStateView(
                        message: context.l10n.teacherStudentsEmpty,
                        icon: Icons.groups_outlined,
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Status Summary Strip (All | Active | Free)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.dimens.lg,
                        context.dimens.xs,
                        context.dimens.lg,
                        context.dimens.sm,
                      ),
                      child: const StudentsSummaryStrip(),
                    ),

                    // 2. Search, Sort & Campus Filters Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimens.lg,
                      ),
                      child: const StudentsFilterBar(),
                    ),
                    SizedBox(height: context.dimens.xs),

                    // 3. Paginated Students Roster List
                    const Expanded(child: StudentsList()),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
