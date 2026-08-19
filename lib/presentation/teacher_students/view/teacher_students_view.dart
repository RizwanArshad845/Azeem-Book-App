import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../viewmodel/teacher_students_viewmodel.dart';
import '../widgets/search_field.dart';
import '../widgets/students_list.dart';

/// Teacher shell Students tab root (§10.2 "Students" — every student
/// enrolled with this teacher, with search & per-student attempt drill-down).
/// Read-only (no primary action): students join by picking this teacher during
/// onboarding, not by being manually added from here.
class TeacherStudentsView extends ConsumerWidget {
  const TeacherStudentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(teacherStudentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.teacherStudentsTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(teacherStudentsProvider);
            ref.invalidate(teacherStudentsSubjectsByIdProvider);
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
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.dimens.lg,
                      context.dimens.md,
                      context.dimens.lg,
                      0,
                    ),
                    child: const StudentSearchField(),
                  ),
                  Expanded(child: StudentsList(students: students)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
