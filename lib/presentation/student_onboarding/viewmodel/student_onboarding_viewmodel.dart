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
  String? _campusId;
  String? _boardClassId;
  final Set<String> _selectedSubjectIds = {};
  final Map<String, String?> _teacherIdBySubjectId = {};

  @override
  Future<Student?> build() async => null;

  String? get campusId => _campusId;

  String? get boardClassId => _boardClassId;

  Set<String> get selectedSubjectIds => Set.unmodifiable(_selectedSubjectIds);

  Map<String, String?> get teacherIdBySubjectId =>
      Map.unmodifiable(_teacherIdBySubjectId);

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
    final campusId = _campusId;
    if (session == null || campusId == null) {
      state = AsyncError<Student?>(
        const ValidationFailure(
          'Select a campus before completing onboarding.',
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
      // `name` isn't collected anywhere in this feature's 3-step
      // campus -> board/class -> subjects flow (no name-entry screen is in
      // scope per this batch's route list) — profile/name editing is a
      // separate not-yet-built feature (§10.2 Profile tab). Placeholder
      // mirrors `AuthDummyDataSourceImpl`'s own placeholder-identity
      // convention so this compiles and round-trips today.
      name: 'Student ${session.phoneNumber}',
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
