import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../../domain/student_onboarding/usecases/complete_student_onboarding_usecase.dart';
import '../../../domain/student_onboarding/usecases/get_teachers_for_campus_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

/// campus -> board/class -> subjects+teachers onboarding flow (§9.1/§9.2,
/// §10.2). Holds in-progress selections across the 3 steps and, on
/// [submit], builds the final `Student` + `SubjectEnrollment` list and
/// calls the use case.
///
/// Note: this project's `pubspec.yaml` does not include `riverpod_generator`
/// / `riverpod_annotation` (only `flutter_riverpod`), so — matching
/// `AuthViewModel` — this is a hand-written `AsyncNotifier` with a manually
/// declared provider rather than `@riverpod` codegen.
class StudentOnboardingViewModel extends AsyncNotifier<Student?> {
  String? _name;
  String? _campusId;
  String? _boardClassId;
  final Set<String> _selectedSubjectIds = {};
  final Map<String, String?> _teacherIdBySubjectId = {};

  @override
  Future<Student?> build() async => null;

  String? get name => _name;

  String? get campusId => _campusId;

  String? get boardClassId => _boardClassId;

  Set<String> get selectedSubjectIds => Set.unmodifiable(_selectedSubjectIds);

  Map<String, String?> get teacherIdBySubjectId =>
      Map.unmodifiable(_teacherIdBySubjectId);

  /// Records the name entered on `StudentNameEntryView`. Called from that
  /// view's "Continue" handler, mirroring [selectCampus] below.
  void recordName(String name) {
    _name = name.trim();
  }

  /// Records the campus chosen on `CampusSelectView`. Called from that
  /// view's "Continue" handler, mirroring `AuthViewModel.selectRole`.
  void selectCampus(String campusId) {
    _campusId = campusId;
  }

  /// Records the board/class chosen on `BoardClassSelectView`. Changing the
  /// board/class invalidates any subject selections made under a
  /// previously-chosen one, since §9.1 scopes subjects strictly to a single
  /// `boardClassId`.
  void selectBoardClass(String boardClassId) {
    _boardClassId = boardClassId;
    _selectedSubjectIds.clear();
    _teacherIdBySubjectId.clear();
  }

  /// Toggles a subject's selection on `SubjectTeacherSelectView`.
  /// Deselecting a subject also clears any teacher assigned to it.
  void toggleSubject(String subjectId) {
    if (_selectedSubjectIds.contains(subjectId)) {
      _selectedSubjectIds.remove(subjectId);
      _teacherIdBySubjectId.remove(subjectId);
    } else {
      _selectedSubjectIds.add(subjectId);
    }
  }

  /// Assigns (or clears, via `null`) a teacher for an already-selected
  /// subject. Selecting a teacher is what triggers the teacher-discount
  /// business rule — enforced at `SubjectEnrollment.create` time in
  /// [submit], not just as a default here.
  void assignTeacher(String subjectId, String? teacherId) {
    if (!_selectedSubjectIds.contains(subjectId)) return;
    _teacherIdBySubjectId[subjectId] = teacherId;
  }

  /// Bulk-replaces every subject/teacher selection in one call. Used by
  /// `SubjectTeacherSelectView`, which (mirroring the local-state-until-
  /// commit pattern used by `CampusSelectView`/`BoardClassSelectView`) keeps
  /// the in-progress multi-select entirely in local widget state and
  /// commits it here just before [submit].
  void replaceSubjectSelections(Map<String, String?> teacherIdBySubjectId) {
    _selectedSubjectIds
      ..clear()
      ..addAll(teacherIdBySubjectId.keys);
    _teacherIdBySubjectId
      ..clear()
      ..addAll(teacherIdBySubjectId);
  }

  /// Builds the final `Student` + `SubjectEnrollment` list from every
  /// selection recorded above and submits it. Deliberately does not signal
  /// navigation — callers should let this `AsyncValue` resolve (router
  /// redirect lands in a separate manual step per this batch's scope).
  Future<void> submit() async {
    final session = ref.read(currentUserProvider);
    final name = _name;
    final campusId = _campusId;
    if (session == null || name == null || name.isEmpty || campusId == null) {
      state = AsyncError<Student?>(
        const ValidationFailure(
          'Enter your name and select a campus before completing onboarding.',
        ),
        StackTrace.current,
      );
      return;
    }

    final now = DateTime.now();
    final enrollments = _selectedSubjectIds
        .map(
          (subjectId) => SubjectEnrollment.create(
            studentId: session.userId,
            subjectId: subjectId,
            teacherId: _teacherIdBySubjectId[subjectId],
          ),
        )
        .toList();

    final student = Student(
      id: session.userId,
      name: name,
      phoneNumber: session.phoneNumber,
      role: session.role,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
      campusId: campusId,
      boardClassId: _boardClassId,
      subjectEnrollments: enrollments.isEmpty ? null : enrollments,
      cartId: null,
    );

    state = const AsyncLoading<Student?>();
    final result = await sl<CompleteStudentOnboardingUseCase>()(student);
    state = result.when(
      success: (saved) => AsyncData<Student?>(saved),
      failure: (failure) => AsyncError<Student?>(failure, StackTrace.current),
    );
  }

  /// Lets other features (`student-profile`'s "Edit profile" action) push
  /// an externally-updated [Student] back into this shared provider after a
  /// successful write, without re-running [build] or touching any of the
  /// in-progress onboarding-selection fields above.
  void setStudent(Student student) {
    state = AsyncData<Student?>(student);
  }
}

final studentOnboardingViewModelProvider =
    AsyncNotifierProvider<StudentOnboardingViewModel, Student?>(
      StudentOnboardingViewModel.new,
    );

// ---------------------------------------------------------------------
// Read-only catalog lookups for the 3 views. These are plain `FutureProvider`s
// (not part of `StudentOnboardingViewModel`'s own `AsyncValue`) because
// they're derived reads scoped to a single screen each, wrapping use cases
// already exposed by campus-directory/catalog
// (`lib/core/di/riverpod_providers.dart`) plus this feature's own
// throwaway teacher-directory use case — not additional business/mutation
// state for the onboarding flow itself.
// ---------------------------------------------------------------------

final campusesProvider = FutureProvider<List<Campus>>((ref) async {
  final result = await ref.read(getCampusesUseCaseProvider)();
  return result.when(success: (campuses) => campuses, failure: (f) => throw f);
});

final boardClassesProvider = FutureProvider<List<BoardClass>>((ref) async {
  final result = await ref.read(getBoardClassesUseCaseProvider)();
  return result.when(
    success: (boardClasses) => boardClasses,
    failure: (f) => throw f,
  );
});

final subjectsForBoardClassProvider =
    FutureProvider.family<List<Subject>, String>((ref, boardClassId) async {
      final result = await ref.read(getSubjectsUseCaseProvider)(boardClassId);
      return result.when(
        success: (subjects) => subjects,
        failure: (f) => throw f,
      );
    });

/// THROWAWAY — see doc comment on [TeacherOption]. `GetTeachersForCampusUseCase`
/// is read from `sl` directly (rather than via `riverpod_providers.dart`,
/// which this unit must not edit) exactly like `submit()` above does for
/// `CompleteStudentOnboardingUseCase`.
final teachersForCampusProvider =
    FutureProvider.family<List<TeacherOption>, String>((ref, campusId) async {
      final result = await sl<GetTeachersForCampusUseCase>()(campusId);
      return result.when(
        success: (teachers) => teachers,
        failure: (f) => throw f,
      );
    });

// ---------------------------------------------------------------------
// Reactive local UI state for individual onboarding screens. `flutter_
// riverpod ^3.4.2` dropped the legacy `StateProvider` (see
// `TeacherStudentsSearchQueryNotifier` for the established precedent this
// mirrors), so these are hand-written `Notifier`s rather than plain field
// mutation on [StudentOnboardingViewModel] — mutating that notifier's
// private fields directly (as `toggleSubject`/`assignTeacher` do) never
// reassigns `state`, so nothing watching it ever rebuilds. Per CLAUDE.md
// §2, `setState` is not an option for this business/shared state either.
// ---------------------------------------------------------------------

/// Selection made on `SubjectTeacherSelectView` — subject id -> optionally
/// assigned teacher id. Kept local to that screen (mirroring the
/// local-state-until-commit pattern `CampusSelectView`/`BoardClassSelectView`
/// use, implemented with Riverpod instead of `setState`) and only written
/// into [StudentOnboardingViewModel] via `replaceSubjectSelections` right
/// before `submit()`. `.autoDispose` means every fresh visit to the screen
/// starts from an empty selection.
class SubjectSelectionViewModel extends Notifier<Map<String, String?>> {
  @override
  Map<String, String?> build() => const {};

  void toggleSubject(String subjectId) {
    final next = Map<String, String?>.from(state);
    if (next.containsKey(subjectId)) {
      next.remove(subjectId);
    } else {
      next[subjectId] = null;
    }
    state = next;
  }

  void assignTeacher(String subjectId, String? teacherId) {
    if (!state.containsKey(subjectId)) return;
    state = {...state, subjectId: teacherId};
  }
}

final subjectSelectionViewModelProvider = NotifierProvider.autoDispose<
  SubjectSelectionViewModel,
  Map<String, String?>
>(SubjectSelectionViewModel.new);

/// Inline validation error shown on `StudentNameEntryView` when Continue is
/// tapped with an empty name. `.autoDispose` clears it on leaving the screen.
class StudentNameErrorViewModel extends Notifier<String?> {
  @override
  String? build() => null;

  void setError(String? message) => state = message;
}

final studentNameErrorViewModelProvider =
    NotifierProvider.autoDispose<StudentNameErrorViewModel, String?>(
      StudentNameErrorViewModel.new,
    );
