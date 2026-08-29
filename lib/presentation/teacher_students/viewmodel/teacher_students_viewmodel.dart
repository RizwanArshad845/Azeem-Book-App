import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/usecases/get_students_for_teacher_usecase.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';

/// Available sorting options for student roster.
enum TeacherStudentsSort { topPerformers, alphabetical, recentlyJoined }

/// All students enrolled with the active teacher.
final teacherStudentsProvider = FutureProvider<List<Student>>((ref) async {
  final teacher = ref.watch(currentTeacherProvider);
  if (teacher == null) {
    return const <Student>[];
  }

  final result = await sl<GetStudentsForTeacherUseCase>()(teacher.id);
  return result.when(
    success: (students) => students,
    failure: (failure) => throw failure,
  );
});

/// Catalog subjects mapped by ID.
final teacherStudentsSubjectsByIdProvider =
    FutureProvider<Map<String, Subject>>((ref) async {
      final students = await ref.watch(teacherStudentsProvider.future);
      final boardClassIds =
          students.map((s) => s.boardClassId).whereType<String>().toSet();

      final getSubjects = ref.read(getSubjectsUseCaseProvider);
      final subjectsById = <String, Subject>{};
      for (final boardClassId in boardClassIds) {
        final result = await getSubjects(boardClassId);
        result.when(
          success:
              (subjects) => subjectsById.addEntries(
                subjects.map((subject) => MapEntry(subject.id, subject)),
              ),
          failure: (failure) => throw failure,
        );
      }
      return subjectsById;
    });

/// Catalog campuses mapped by ID for student campus name resolution.
final teacherStudentsCampusesByIdProvider =
    FutureProvider<Map<String, Campus>>((ref) async {
      final getCampuses = ref.read(getCampusesUseCaseProvider);
      final result = await getCampuses();
      return result.when(
        success:
            (campuses) => {for (final campus in campuses) campus.id: campus},
        failure: (_) => {},
      );
    });

/// Search text query notifier.
class TeacherStudentsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

final teacherStudentsSearchQueryProvider =
    NotifierProvider<TeacherStudentsSearchQueryNotifier, String>(
      TeacherStudentsSearchQueryNotifier.new,
    );

/// Campus filter ID notifier (null for All).
class TeacherStudentsCampusFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCampus(String? campusId) => state = campusId;
}

final teacherStudentsCampusFilterProvider =
    NotifierProvider<TeacherStudentsCampusFilterNotifier, String?>(
      TeacherStudentsCampusFilterNotifier.new,
    );

/// Status filter notifier: 'all' | 'active' | 'free'.
class TeacherStudentsStatusFilterNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setStatus(String status) => state = status;
}

final teacherStudentsStatusFilterProvider =
    NotifierProvider<TeacherStudentsStatusFilterNotifier, String>(
      TeacherStudentsStatusFilterNotifier.new,
    );

/// Sorting option notifier.
class TeacherStudentsSortNotifier extends Notifier<TeacherStudentsSort> {
  @override
  TeacherStudentsSort build() => TeacherStudentsSort.recentlyJoined;

  void setSort(TeacherStudentsSort sort) => state = sort;
}

final teacherStudentsSortProvider =
    NotifierProvider<TeacherStudentsSortNotifier, TeacherStudentsSort>(
      TeacherStudentsSortNotifier.new,
    );

/// Current page notifier for pagination.
class TeacherStudentsCurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void setPage(int page) => state = page;
  void nextPage() => state = state + 1;
  void prevPage() => state = (state - 1).clamp(1, 9999);
}

final teacherStudentsCurrentPageProvider =
    NotifierProvider<TeacherStudentsCurrentPageNotifier, int>(
      TeacherStudentsCurrentPageNotifier.new,
    );

/// Combined filtered and sorted students list.
final teacherStudentsFilteredListProvider = Provider<List<Student>>((ref) {
  final students = ref.watch(teacherStudentsProvider).value ?? [];
  final query = ref.watch(teacherStudentsSearchQueryProvider).trim().toLowerCase();
  final campusFilter = ref.watch(teacherStudentsCampusFilterProvider);
  final statusFilter = ref.watch(teacherStudentsStatusFilterProvider);
  final sort = ref.watch(teacherStudentsSortProvider);

  var list = students.where((s) {
    // 1. Search Query
    if (query.isNotEmpty) {
      final nameMatches = s.name.toLowerCase().contains(query);
      final phoneMatches = s.phoneNumber.toLowerCase().contains(query);
      if (!nameMatches && !phoneMatches) return false;
    }

    // 2. Campus Filter
    if (campusFilter != null && s.campusId != campusFilter) {
      return false;
    }

    // 3. Status Filter (Active / Free)
    final isPaid = (s.subjectEnrollments ?? []).any((e) => e.discountApplied);
    if (statusFilter == 'active' && !isPaid) return false;
    if (statusFilter == 'free' && isPaid) return false;

    return true;
  }).toList();

  // Sort
  switch (sort) {
    case TeacherStudentsSort.alphabetical:
      list.sort((a, b) => a.name.compareTo(b.name));
      break;
    case TeacherStudentsSort.recentlyJoined:
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case TeacherStudentsSort.topPerformers:
      // Active paid students first, then alphabetical
      list.sort((a, b) {
        final aPaid = (a.subjectEnrollments ?? []).any((e) => e.discountApplied);
        final bPaid = (b.subjectEnrollments ?? []).any((e) => e.discountApplied);
        if (aPaid && !bPaid) return -1;
        if (!aPaid && bPaid) return 1;
        return a.name.compareTo(b.name);
      });
      break;
  }

  return list;
});

/// Returns the list of subject names that [student] is enrolled in with [teacher].
List<String> teacherStudentSubjectsFor(
  Student student,
  Teacher teacher,
  Map<String, Subject> subjectsById,
) {
  final enrollments = student.subjectEnrollments ?? const [];
  return enrollments
      .where((e) => e.teacherId == teacher.id)
      .map((e) => subjectsById[e.subjectId]?.name ?? e.subjectId)
      .toList();
}
