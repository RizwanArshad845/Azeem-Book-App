import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/class_level.dart';
import '../../../domain/catalog/entities/subject.dart';

import '../../teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';

/// Board-class catalog keyed by id, for resolving `Teacher.classIds` to
/// display names (`teacher.dart`: "resolve display names via the catalog
/// subjects/board-classes lists, don't render these raw").
final teacherProfileBoardClassesByIdProvider =
    FutureProvider<Map<String, BoardClass>>((ref) async {
  final classes = await ref.watch(boardClassesProvider.future);
  return {for (final c in classes) c.id: c};
});

/// Class-level catalog keyed by id — fallback for a `classId` that refers to
/// a bare class level rather than a board-class group.
final teacherProfileClassLevelsByIdProvider =
    FutureProvider<Map<String, ClassLevel>>((ref) async {
  final levels = await ref.watch(classLevelsProvider.future);
  return {for (final l in levels) l.id: l};
});

/// Subjects for a teacher's own declared classes and subjects — independent of the
/// student roster (unlike `teacherStudentsSubjectsByIdProvider`), so it
/// resolves correctly even for a teacher with zero enrolled students.
final teacherProfileResolvedSubjectsProvider =
    FutureProvider<Map<String, Subject>>((ref) async {
  final teacher = ref.watch(
    teacherOnboardingViewModelProvider.select((s) => s.value),
  );
  if (teacher == null) return const <String, Subject>{};

  final getSubjects = ref.read(getSubjectsUseCaseProvider);
  final subjectsById = <String, Subject>{};

  // 1. Fetch subjects for the teacher's declared classes
  final classIds = teacher.classIds ?? const [];
  for (final classId in classIds) {
    final result = await getSubjects(classId);
    result.when(
      success: (subjects) {
        for (final subject in subjects) {
          subjectsById[subject.id] = subject;
        }
      },
      failure: (_) {},
    );
  }

  // 2. If any declared subjectId is not yet in subjectsById, search all board classes
  final missingIds = teacher.subjectIds
      .where((id) => !subjectsById.containsKey(id))
      .toList();
  if (missingIds.isNotEmpty) {
    final allClasses = await ref.watch(boardClassesProvider.future);
    for (final bc in allClasses) {
      if (classIds.contains(bc.id)) continue;
      final result = await getSubjects(bc.id);
      result.when(
        success: (subjects) {
          for (final s in subjects) {
            subjectsById[s.id] = s;
          }
        },
        failure: (_) {},
      );
      if (missingIds.every((id) => subjectsById.containsKey(id))) {
        break;
      }
    }
  }

  return subjectsById;
});
