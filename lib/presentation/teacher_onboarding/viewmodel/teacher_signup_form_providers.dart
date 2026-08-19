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

/// Subjects available for the currently-selected `classes` (BoardClass ids).
/// `classIdsKey` is the selected ids sorted and comma-joined so the
/// `family` cache key is stable regardless of selection order.
/// `GetSubjectsUseCase` takes a single `boardClassId`, so each selected
/// class is queried individually and the results de-duplicated/merged —
/// `classes` (Teacher's own field, FK BoardClass.id) and `Subject.boardClassId`
/// both reference the same `BoardClass.id`, so no extra lookup is needed.
final teacherSignupSubjectsForClassesProvider = FutureProvider.autoDispose
    .family<List<Subject>, String>((ref, classIdsKey) async {
      if (classIdsKey.isEmpty) return const [];
      final classIds = classIdsKey.split(',');
      final getSubjects = ref.read(getSubjectsUseCaseProvider);

      final lists = await Future.wait(
        classIds.map((classId) async {
          final result = await getSubjects(classId);
          return result.when(success: (v) => v, failure: (f) => throw f);
        }),
      );

      final seenIds = <String>{};
      final merged = <Subject>[];
      for (final subject in lists.expand((list) => list)) {
        if (seenIds.add(subject.id)) merged.add(subject);
      }
      return merged;
    });
