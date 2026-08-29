import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/subject.dart';

/// Read-only providers feeding the teacher signup form's catalog pickers.
/// Wraps the already-registered `getCampusesUseCaseProvider` /
/// `getBoardClassesUseCaseProvider` / `getSubjectsUseCaseProvider` from
/// `core/di/riverpod_providers.dart` (read, not edited — that file is a
/// shared hotspot owned by the coordinating thread) in `FutureProvider`s so
/// the view can render them with `AsyncValueWidget` like everything else.

/// Full campus directory for the campus dropdown.
final teacherSignupCampusesProvider = FutureProvider.autoDispose<List<Campus>>(
  (ref) async {
    final result = await ref.read(getCampusesUseCaseProvider)();
    return result.when(success: (v) => v, failure: (f) => throw f);
  },
);

/// Only Admin-enabled board/classes are selectable (§9.2: disabled ones
/// render as "coming soon" and shouldn't appear in this form at all).
final teacherSignupBoardClassesProvider =
    FutureProvider.autoDispose<List<BoardClass>>((ref) async {
      final result = await ref.read(getBoardClassesUseCaseProvider)();
      return result.when(
        success: (v) => v.where((b) => b.isEnabled).toList(),
        failure: (f) => throw f,
      );
    });

/// A subject name shared by one or more of the currently-selected classes,
/// carrying every underlying [Subject.id] it maps to (e.g. "Physics" taught
/// in both Pre-Medical and Pre-Engineering merges into one row here with
/// both classes' subject ids) — `classes` are catalogued per-`BoardClass`,
/// so the same subject *name* legitimately exists as multiple distinct
/// [Subject] rows (different ids, different `boardClassId`) across streams;
/// deduplicating by [Subject.id] alone (the previous approach) let "Physics"
/// appear once per class it's taught in instead of once overall.
class UniqueTeacherSubject {
  const UniqueTeacherSubject({required this.name, required this.subjectIds});

  final String name;
  final List<String> subjectIds;

  String get id => name;
}

/// Subjects available for the currently-selected `classes` (BoardClass ids),
/// deduplicated by name so a subject taught across multiple selected
/// classes only appears once. `classIdsKey` is the selected ids sorted and
/// comma-joined so the `family` cache key is stable regardless of selection
/// order. `GetSubjectsUseCase` takes a single `boardClassId`, so each
/// selected class is queried individually and the results merged by name.
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

      final idsByName = <String, List<String>>{};
      final displayNames = <String, String>{};
      for (final subject in lists.expand((list) => list)) {
        final key = subject.name.trim().toLowerCase();
        idsByName.putIfAbsent(key, () => []).add(subject.id);
        displayNames.putIfAbsent(key, () => subject.name.trim());
      }

      return idsByName.entries
          .map(
            (entry) => UniqueTeacherSubject(
              name: displayNames[entry.key] ?? entry.key,
              subjectIds: entry.value,
            ),
          )
          .toList();
    });
