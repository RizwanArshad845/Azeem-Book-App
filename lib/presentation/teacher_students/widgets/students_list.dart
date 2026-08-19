import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';
import '../viewmodel/teacher_students_viewmodel.dart';
import 'student_card.dart';

class StudentsList extends ConsumerWidget {
  const StudentsList({super.key, required this.students});

  final List<Student> students;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(teacherStudentsSearchQueryProvider);
    final teacher = ref.watch(currentTeacherProvider);
    final subjectsByIdAsync = ref.watch(teacherStudentsSubjectsByIdProvider);
    final subjectsById = subjectsByIdAsync.value ?? const <String, Subject>{};

    final filtered = students
        .where((s) => teacherStudentMatchesQuery(s, query))
        .toList();

    if (filtered.isEmpty) {
      return ListView(
        padding: EdgeInsets.all(context.dimens.lg),
        children: [
          EmptyStateView(message: context.l10n.teacherStudentsSearchNoMatch),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.dimens.lg),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
      itemBuilder: (context, index) {
        final student = filtered[index];

        final subjectNames = teacher == null
            ? const <String>[]
            : teacherStudentSubjectsFor(student, teacher, subjectsById);

        return StudentCard(
          student: student,
          subjectNames: subjectNames,
          onTap: () => context.push(
            AppRoutes.teacherStudentProgressDetailPath(student.id),
          ),
        );
      },
    );
  }
}
