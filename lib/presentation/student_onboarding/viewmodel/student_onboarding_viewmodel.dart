import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/repositories/catalog_repository.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_cart/repositories/cart_repository.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../../domain/student_onboarding/usecases/complete_student_onboarding_usecase.dart';
import '../../../domain/student_onboarding/usecases/get_student_by_id_usecase.dart';
import '../../../domain/student_onboarding/usecases/get_teachers_for_campus_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

export '../../../core/di/riverpod_providers.dart'
    show boardClassesProvider, campusesProvider, classLevelsProvider;

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

  /// Re-derives the current student whenever [currentUserProvider] changes,
  /// mirroring `TeacherOnboardingViewModel.build()`. Without this, a
  /// previous user's cached `Student` survived logout/relogin in this
  /// process-lifetime `ProviderContainer` and was shown to whichever
  /// different student logged in next.
  @override
  Future<Student?> build() async {
    final session = ref.watch(currentUserProvider);
    if (session == null || session.userId == null) return null;

    // A teacher session has no row in the students table by definition —
    // resolve to null immediately instead of firing a guaranteed-404
    // `GET /students/{teacherId}` (this was happening on every single
    // teacher login, confirmed via device logs, since nothing here checked
    // role before calling `GetStudentByIdUseCase`).
    if (session.role != UserRole.student) return null;

    // Backend commit cb7deb0: `status` is already known synchronously from
    // the OTP-verify response — a `NOT_REGISTERED` session has no `Student`
    // row yet by definition, so resolving to `null` here immediately (no
    // network round-trip) both saves a guaranteed-404 `GET /students/{id}`
    // call and closes the brief async window where the router's redirect
    // (`_redirectFor`) would otherwise allow the in-flight location through
    // before this provider settles.
    if (session.status == 'NOT_REGISTERED') return null;

    var result = await sl<GetStudentByIdUseCase>()(session.userId!);
    if (result is ResultFailure<Student> && result.failure is NetworkFailure) {
      // Absorb a single transient *network* blip (e.g. a fresh login
      // racing a still-settling connection) with one retry before giving
      // up. The router has no self-healing path for a terminal
      // `AsyncError` on this provider (it just holds on splash — see
      // `app_router.dart`), so a failure here would otherwise be a dead
      // end for a genuinely registered student. Deliberately scoped to
      // `NetworkFailure`: a 404/401/500 won't be fixed by waiting 800ms
      // and retrying, so don't pay that cost for failures a retry can't
      // help.
      await Future.delayed(const Duration(milliseconds: 800));
      result = await sl<GetStudentByIdUseCase>()(session.userId!);
    }
    return result.when(
      success: (student) => student,
      failure: (failure) => throw failure,
    );
  }

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
            studentId: session.userId!,
            subjectId: subjectId,
            teacherId: _teacherIdBySubjectId[subjectId],
          ),
        )
        .toList();

    final student = Student(
      id: session.userId!,
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
    if (result is Success<Student>) {
      final saved = result.data;
      // Preload dashboard network calls (enrolled subjects, tests, chapters, cart)
      // while the submit button is in loading state, so user experiences no lag on dashboard
      await _preloadDashboardData(saved);
      state = AsyncData<Student?>(saved);
    } else if (result is ResultFailure<Student>) {
      state = AsyncError<Student?>(result.failure, StackTrace.current);
    }
  }

  Future<void> _preloadDashboardData(Student student) async {
    try {
      final boardClassId = student.boardClassId;
      final enrolledIds = (student.subjectEnrollments ?? const [])
          .map((e) => e.subjectId)
          .toList();

      final catalogRepo = sl<CatalogRepository>();
      final futures = <Future<dynamic>>[];

      // 1. Fetch all subjects for this board class
      if (boardClassId != null) {
        futures.add(catalogRepo.getSubjects(boardClassId));
      }

      // 2. Fetch tests and chapters for each enrolled subject
      for (final subjectId in enrolledIds) {
        futures.add(catalogRepo.getTests(subjectId: subjectId));
        futures.add(catalogRepo.getChapters(subjectId));
      }

      // 3. Preload purchased subject ids and cart
      try {
        final cartRepo = sl<CartRepository>();
        futures.add(cartRepo.getPurchasedSubjectIds(student.id));
        futures.add(cartRepo.getCart(student.id));
      } catch (_) {}

      await Future.wait<dynamic>(futures).timeout(const Duration(seconds: 4));
    } catch (_) {
      // Graceful fallback: preload failure shouldn't fail onboarding submission
    }
  }

  /// Lets other features (`student-profile`'s "Edit profile" action) push
  /// an externally-updated [Student] back into this shared provider after a
  /// successful write, without re-running [build] or touching any of the
  /// in-progress onboarding-selection fields above.
  void setStudent(Student student) {
    state = AsyncData<Student?>(student);
  }

  /// Re-fetches the current student's profile from the backend and updates state.
  Future<Student?> refreshStudent() async {
    final session = ref.read(currentUserProvider);
    if (session == null || session.userId == null) return null;
    final result = await sl<GetStudentByIdUseCase>()(session.userId!);
    final fresh = result.when(
      success: (s) => s,
      failure: (_) => null,
    );
    if (fresh != null) {
      state = AsyncData<Student?>(fresh);
    }
    return fresh;
  }
}

final studentOnboardingViewModelProvider =
    AsyncNotifierProvider<StudentOnboardingViewModel, Student?>(
      StudentOnboardingViewModel.new,
    );

// ---------------------------------------------------------------------
// Read-only catalog lookups for the 3 views.
// Note: campusesProvider, boardClassesProvider, and classLevelsProvider
// are defined in `lib/core/di/riverpod_providers.dart` and re-exported above.
// ---------------------------------------------------------------------

/// [BoardClass] leaves under a single [classLevelId], filtered client-side
/// from [boardClassesProvider]'s full list (`GetBoardClassesUseCase` has no
/// filtered variant, and the full catalog is small — see plan §3). Powers
/// the auto-select-if-single-leaf / show-group-picker-if-multiple logic on
/// `StudentAcademicInfoView`.
final boardClassesForClassLevelProvider =
    FutureProvider.family<List<BoardClass>, String>((ref, classLevelId) async {
      final boardClasses = await ref.watch(boardClassesProvider.future);
      return boardClasses
          .where((b) => b.classLevelId == classLevelId)
          .toList();
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

  /// Wipes every in-progress selection. Called whenever an upstream scope
  /// change (class level or board class/group) makes the current selection
  /// meaningless — without this, a subject id picked under a previously
  /// viewed group survives into `replaceSubjectSelections` at Confirm time
  /// and the Review screen renders it as an unresolved raw id (it's not
  /// present in the new group's `subjectsForBoardClassProvider` list).
  void clear() => state = const {};
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

/// Campus tapped/picked on `StudentBasicInfoView`. Replaces that screen's
/// (deleted) local `setState`-based `_selected` field — CLAUDE.md forbids
/// `setState` for anything that drives what a screen renders, including a
/// dropdown selection that gates the "Continue" button. `.autoDispose`
/// clears it on leaving the screen, same as [StudentNameErrorViewModel].
class SelectedCampusViewModel extends Notifier<Campus?> {
  @override
  Campus? build() => null;

  void select(Campus? campus) => state = campus;
}

final selectedCampusViewModelProvider =
    NotifierProvider.autoDispose<SelectedCampusViewModel, Campus?>(
      SelectedCampusViewModel.new,
    );

/// `ClassLevel.id` tapped on `StudentAcademicInfoView`'s class list.
/// Selecting a new class level also resets [selectedBoardClassViewModelProvider]
/// (mirrors [StudentOnboardingViewModel.selectBoardClass] clearing subject
/// selections on a board/class change) since a leaf chosen under the
/// previous class level is meaningless under a new one.
class SelectedClassLevelViewModel extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? classLevelId) {
    state = classLevelId;
    ref.read(selectedBoardClassViewModelProvider.notifier).select(null);
    ref.read(subjectSelectionViewModelProvider.notifier).clear();
  }
}

final selectedClassLevelViewModelProvider =
    NotifierProvider.autoDispose<SelectedClassLevelViewModel, String?>(
      SelectedClassLevelViewModel.new,
    );

/// Resolved leaf `BoardClass.id` on `StudentAcademicInfoView` — either
/// auto-selected (class levels with exactly one enabled leaf, e.g. 9th/10th)
/// or user-picked from the Group picker (class levels with more than one
/// enabled leaf, e.g. 11th/12th's Pre-Medical/Pre-Engineering).
class SelectedBoardClassViewModel extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? boardClassId) {
    if (state != boardClassId) {
      ref.read(subjectSelectionViewModelProvider.notifier).clear();
    }
    state = boardClassId;
  }
}

final selectedBoardClassViewModelProvider =
    NotifierProvider.autoDispose<SelectedBoardClassViewModel, String?>(
      SelectedBoardClassViewModel.new,
    );
