import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../viewmodel/teacher_students_viewmodel.dart';
import '../widgets/students_filter_bar.dart';
import '../widgets/students_list.dart';

/// Teacher Students directory tab: live search, sorting, status filter
/// chips with counts, and pagination.
class TeacherStudentsView extends ConsumerWidget {
  const TeacherStudentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(teacherStudentsProvider);

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.teacherStudentsTitle)),
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
              skeleton: Padding(
                padding: EdgeInsets.all(context.dimens.lg),
                child: const SkeletonList(itemCount: 5, itemHeight: 96),
              ),
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
                    // 1. Search, Sort & status filter chips (with counts)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.dimens.lg,
                        context.dimens.sm,
                        context.dimens.lg,
                        0,
                      ),
                      child: const StudentsFilterBar(),
                    ),
                    SizedBox(height: context.dimens.xs),

                    // 2. Paginated Students Roster List
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
