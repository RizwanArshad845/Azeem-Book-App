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
    return ref.watch(campusesProvider.future);
  },
);

/// Only Admin-enabled board/classes are selectable (§9.2: disabled ones
/// render as "coming soon" and shouldn't appear in this form at all).
final teacherSignupBoardClassesProvider =
    FutureProvider.autoDispose<List<BoardClass>>((ref) async {
      final boardClasses = await ref.watch(boardClassesProvider.future);
      return boardClasses.where((b) => b.isEnabled).toList();
    });

/// A `BoardClass` display name shared by more than one underlying leaf,
/// carrying every leaf id it maps to — e.g. "Pre-Medical" is seeded once
/// under `cl-11` ("1st year") and again under `cl-12` ("2nd year"), so a
/// teacher who teaches Pre-Medical shouldn't have to pick it twice. Mirrors
/// [UniqueTeacherSubject]'s dedup-by-name shape below.
class UniqueTeacherBoardClass {
  const UniqueTeacherBoardClass({required this.name, required this.ids});

  final String name;
  final List<String> ids;

  String get id => name;
}

/// Deduped, teacher-facing class list: groups [teacherSignupBoardClassesProvider]'s
/// leaves by display name (folding the 1st-year/2nd-year duplicates for
/// Pre-Medical/Pre-Engineering/I.Com/F.A/I.C.S into one row each) and drops
/// `classLevelId: 'cl-10'` leaves — `cl-10` itself was retired from
/// `ClassLevel` (see `CatalogDummyDataSource._seed`'s "10th" comment) so its
/// board class is unreachable and shouldn't still show up here.
final teacherSignupUniqueBoardClassesProvider =
    FutureProvider.autoDispose<List<UniqueTeacherBoardClass>>((ref) async {
      final boardClasses = await ref.watch(
        teacherSignupBoardClassesProvider.future,
      );

      final idsByName = <String, List<String>>{};
      final displayNames = <String, String>{};
      for (final boardClass in boardClasses) {
        if (boardClass.classLevelId == 'cl-10') continue;
        final key = boardClass.name.trim().toLowerCase();
        idsByName.putIfAbsent(key, () => []).add(boardClass.id);
        displayNames.putIfAbsent(key, () => boardClass.name.trim());
      }

      return idsByName.entries
          .map(
            (entry) => UniqueTeacherBoardClass(
              name: displayNames[entry.key] ?? entry.key,
              ids: entry.value,
            ),
          )
          .toList();
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
