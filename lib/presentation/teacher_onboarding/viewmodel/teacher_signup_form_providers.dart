import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/campus_directory/entities/campus.dart';

/// Read-only providers feeding the teacher signup form's catalog pickers.

/// Full campus directory for the campus dropdown.
final teacherSignupCampusesProvider = FutureProvider.autoDispose<List<Campus>>(
  (ref) async {
    final result = await ref.read(getCampusesUseCaseProvider)();
    return result.when(success: (v) => v, failure: (f) => throw f);
  },
);

/// Option model pairing a BoardClass with an unambiguous display title
/// (e.g. "11th (Pre-Medical)" vs "12th (Pre-Medical)").
class TeacherClassOption {
  const TeacherClassOption({
    required this.id,
    required this.displayName,
    required this.rawName,
    required this.classLevelName,
  });

  final String id;
  final String displayName;
  final String rawName;
  final String classLevelName;
}

/// Only Admin-enabled board/classes with clear unambiguous grade-level labels.
final teacherSignupClassOptionsProvider =
    FutureProvider.autoDispose<List<TeacherClassOption>>((ref) async {
      final boardClassesResult =
          await ref.read(getBoardClassesUseCaseProvider)();
      final classLevelsResult =
          await ref.read(getClassLevelsUseCaseProvider)();

      final boardClasses = boardClassesResult.when(
        success: (v) => v.where((b) => b.isEnabled).toList(),
        failure: (f) => throw f,
      );

      final classLevels = classLevelsResult.when(
        success: (v) => {for (final cl in v) cl.id: cl.name},
        failure: (_) => <String, String>{},
      );

      return boardClasses.map((bc) {
        final levelName = classLevels[bc.classLevelId] ?? '';
        final String displayName;
        if (levelName.isNotEmpty &&
            !bc.name.toLowerCase().contains(levelName.toLowerCase())) {
          displayName = '$levelName (${bc.name})';
        } else {
          displayName = bc.name;
        }

        return TeacherClassOption(
          id: bc.id,
          displayName: displayName,
          rawName: bc.name,
          classLevelName: levelName,
        );
      }).toList();
    });

/// Model for a unique subject name displayed to the teacher.
/// Maps 1 unique display subject name (e.g. "Physics") to all underlying
/// subject IDs across the selected classes (e.g. `['subj-11pm-phy', 'subj-12pm-phy']`).
class UniqueTeacherSubject {
  const UniqueTeacherSubject({
    required this.name,
    required this.subjectIds,
  });

  final String name;
  final List<String> subjectIds;

  String get id => name;
}

/// Subjects available for the currently-selected `classes`, deduplicated by name
/// so common subjects (e.g. "Physics", "Chemistry") only appear once.
final teacherSignupSubjectsForClassesProvider = FutureProvider.autoDispose
    .family<List<UniqueTeacherSubject>, String>((ref, classIdsKey) async {
      if (classIdsKey.isEmpty) return const [];
      final classIds = classIdsKey.split(',');
      final getSubjects = ref.read(getSubjectsUseCaseProvider);

      final lists = await Future.wait(
        classIds.map((classId) async {
          final result = await getSubjects(classId);
          return result.when(success: (v) => v, failure: (f) => throw f);
        }),
      );

      final groupedByName = <String, List<String>>{};
      final displayNames = <String, String>{};

      for (final subject in lists.expand((list) => list)) {
        final key = subject.name.trim().toLowerCase();
        groupedByName.putIfAbsent(key, () => []).add(subject.id);
        displayNames.putIfAbsent(key, () => subject.name.trim());
      }

      return groupedByName.entries.map((entry) {
        return UniqueTeacherSubject(
          name: displayNames[entry.key] ?? entry.key,
          subjectIds: entry.value,
        );
      }).toList();
    });
