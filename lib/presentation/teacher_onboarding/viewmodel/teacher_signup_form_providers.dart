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

/// Distinct sorted cities derived from the campus directory.
final teacherSignupCitiesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final campuses = await ref.watch(teacherSignupCampusesProvider.future);
  final cities =
      campuses
          .map((c) => c.city.trim())
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
  return cities;
});

/// Campuses filtered by the selected city.
final teacherSignupCampusesByCityProvider =
    FutureProvider.autoDispose.family<List<Campus>, String>((ref, city) async {
      if (city.isEmpty) return const <Campus>[];
      final campuses = await ref.watch(teacherSignupCampusesProvider.future);
      return campuses
          .where((c) => c.city.trim().toLowerCase() == city.trim().toLowerCase())
          .toList();
    });

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

/// Business state for the multi-step teacher signup wizard (§2 state-management
/// rule: this is the actual `submitSignUp(...)` payload, so it belongs in
/// Riverpod, not raw `StatefulWidget` fields). Mirrors the small-dedicated-Notifier
/// pattern used by `teacher_students_viewmodel.dart`.
class TeacherSignupSelectedCityNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCity(String? city) => state = city;
}

final teacherSignupSelectedCityProvider =
    NotifierProvider<TeacherSignupSelectedCityNotifier, String?>(
      TeacherSignupSelectedCityNotifier.new,
    );

class TeacherSignupSelectedCampusIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void setCampusIds(Set<String> ids) => state = ids;
  void clear() => state = <String>{};
}

final teacherSignupSelectedCampusIdsProvider = NotifierProvider<
  TeacherSignupSelectedCampusIdsNotifier,
  Set<String>
>(TeacherSignupSelectedCampusIdsNotifier.new);

class TeacherSignupSelectedClassIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void setClassIds(Set<String> ids) => state = ids;
}

final teacherSignupSelectedClassIdsProvider = NotifierProvider<
  TeacherSignupSelectedClassIdsNotifier,
  Set<String>
>(TeacherSignupSelectedClassIdsNotifier.new);

class TeacherSignupSelectedSubjectNamesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void setSubjectNames(Set<String> names) => state = names;
  void clear() => state = <String>{};
}

final teacherSignupSelectedSubjectNamesProvider = NotifierProvider<
  TeacherSignupSelectedSubjectNamesNotifier,
  Set<String>
>(TeacherSignupSelectedSubjectNamesNotifier.new);

class TeacherSignupDeclaredStudentCountNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setCount(int? count) => state = count;
}

final teacherSignupDeclaredStudentCountProvider =
    NotifierProvider<TeacherSignupDeclaredStudentCountNotifier, int?>(
      TeacherSignupDeclaredStudentCountNotifier.new,
    );

/// One small `Notifier<String?>` per field-level validation error, holding the
/// already-localized message (or null) — mirrors the original per-field error
/// strings, just Riverpod-backed instead of `setState`.
class TeacherSignupFieldErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? message) => state = message;
}

final teacherSignupNameErrorProvider =
    NotifierProvider<TeacherSignupFieldErrorNotifier, String?>(
      TeacherSignupFieldErrorNotifier.new,
    );
final teacherSignupCityErrorProvider =
    NotifierProvider<TeacherSignupFieldErrorNotifier, String?>(
      TeacherSignupFieldErrorNotifier.new,
    );
final teacherSignupCampusesErrorProvider =
    NotifierProvider<TeacherSignupFieldErrorNotifier, String?>(
      TeacherSignupFieldErrorNotifier.new,
    );
final teacherSignupClassesErrorProvider =
    NotifierProvider<TeacherSignupFieldErrorNotifier, String?>(
      TeacherSignupFieldErrorNotifier.new,
    );
final teacherSignupSubjectsErrorProvider =
    NotifierProvider<TeacherSignupFieldErrorNotifier, String?>(
      TeacherSignupFieldErrorNotifier.new,
    );

/// Resets every piece of signup-form business state back to its initial value.
/// Call when the signup form is first shown so a previous attempt's state
/// (e.g. after navigating away and back) never leaks into a fresh one.
void resetTeacherSignupFormState(WidgetRef ref) {
  ref.read(teacherSignupSelectedCityProvider.notifier).setCity(null);
  ref.read(teacherSignupSelectedCampusIdsProvider.notifier).clear();
  ref.read(teacherSignupSelectedClassIdsProvider.notifier).setClassIds({});
  ref.read(teacherSignupSelectedSubjectNamesProvider.notifier).clear();
  ref
      .read(teacherSignupDeclaredStudentCountProvider.notifier)
      .setCount(null);
  ref.read(teacherSignupNameErrorProvider.notifier).set(null);
  ref.read(teacherSignupCityErrorProvider.notifier).set(null);
  ref.read(teacherSignupCampusesErrorProvider.notifier).set(null);
  ref.read(teacherSignupClassesErrorProvider.notifier).set(null);
  ref.read(teacherSignupSubjectsErrorProvider.notifier).set(null);
}
