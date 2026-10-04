import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/usecases/add_student_subject_enrollment_usecase.dart';
import '../../../domain/student_onboarding/usecases/set_student_subject_teacher_usecase.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import 'student_home_viewmodel.dart';

/// State for the assign-teacher bottom sheet.
class AssignTeacherState {
  const AssignTeacherState({
    required this.selectedTeacherId,
    this.isSaving = false,
  });

  final String? selectedTeacherId;
  final bool isSaving;

  AssignTeacherState copyWith({
    String? Function()? selectedTeacherId,
    bool? isSaving,
  }) {
    return AssignTeacherState(
      selectedTeacherId: selectedTeacherId != null
          ? selectedTeacherId()
          : this.selectedTeacherId,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Manages selected-teacher and saving state for [AssignTeacherSheet].
///
/// Keyed on the initial teacher ID so each sheet instance starts with the
/// correct pre-selection. [autoDispose] ensures the state is cleaned up when
/// the sheet is dismissed.
class AssignTeacherViewModel extends Notifier<AssignTeacherState> {
  AssignTeacherViewModel(this._initialTeacherId);

  final String? _initialTeacherId;

  @override
  AssignTeacherState build() =>
      AssignTeacherState(selectedTeacherId: _initialTeacherId);

  /// Selects (or clears) [teacherId].
  void select(String? teacherId) {
    state = state.copyWith(selectedTeacherId: () => teacherId);
  }

  /// Persists the current selection and shows a confirmation snackbar.
  ///
  /// Accepts [BuildContext] for snackbar display; all async work is
  /// encapsulated here so the view can call this as a plain `void` method.
  void save({
    required WidgetRef ref,
    required BuildContext context,
    required String subjectId,
  }) {
    _save(ref: ref, context: context, subjectId: subjectId);
  }

  Future<void> _save({
    required WidgetRef ref,
    required BuildContext context,
    required String subjectId,
  }) async {
    final student = ref.read(currentStudentProvider);
    if (student == null) return;

    state = state.copyWith(isSaving: true);

    final teacherId = state.selectedTeacherId;
    final currentEnrollments =
        student.subjectEnrollments ?? <SubjectEnrollment>[];
    final alreadyEnrolled = currentEnrollments.any(
      (e) => e.subjectId == subjectId,
    );

    // One subject at a time: POST adds it (teacher optional), PATCH changes
    // or removes the teacher of an existing one. The other subjects are never
    // sent, so nothing else can be dropped or locked by accident.
    var result = alreadyEnrolled
        ? await _setTeacher(student.id, subjectId, teacherId)
        : await sl<AddStudentSubjectEnrollmentUseCase>()(
            student.id,
            subjectId,
            teacherId: teacherId,
          );
    // Stale local list (e.g. added on another device): the backend says it's
    // already there, so just set the teacher on it instead.
    if (result case ResultFailure(failure: AlreadyEnrolledFailure())) {
      result = await _setTeacher(student.id, subjectId, teacherId);
    }

    if (!context.mounted) return;
    state = state.copyWith(isSaving: false);

    result.when(
      success: (saved) {
        final updated = [
          for (final e in currentEnrollments)
            if (e.subjectId != subjectId) e,
          saved.copyWith(studentId: student.id),
        ];
        ref
            .read(studentOnboardingViewModelProvider.notifier)
            .setStudent(student.copyWith(subjectEnrollments: updated));
        _refreshCatalogForBoardClass(ref, student.boardClassId);
        // Prices change when a teacher is set or removed.
        ref.invalidate(studentCartViewModelProvider);
        Navigator.of(context).pop();
        AppSnackbar.show(
          context,
          saved.teacherId != null
              ? context.l10n.assignTeacherSavedSuccess
              : context.l10n.assignTeacherSetSelfStudy,
        );
      },
      failure: (failure) {
        if (failure is TeacherLockedAfterPurchaseFailure) {
          // Bought (maybe on another device): mark it locally so the UI
          // stops offering the change.
          ref.read(studentOnboardingViewModelProvider.notifier).setStudent(
                student.copyWith(
                  subjectEnrollments: [
                    for (final e in currentEnrollments)
                      e.subjectId == subjectId ? e.copyWith(isPaid: true) : e,
                  ],
                ),
              );
          Navigator.of(context).pop();
        } else if (failure is TeacherNotSelectableFailure) {
          // Stale list — reload it so the unavailable teacher disappears.
          final campusId = student.campusId;
          if (campusId.isNotEmpty) {
            ref.invalidate(teachersForCampusProvider(campusId));
          }
          select(_initialTeacherId);
        }
        AppSnackbar.show(context, failure.localizedMessage(context));
      },
    );
  }

  Future<Result<SubjectEnrollment>> _setTeacher(
    String studentId,
    String subjectId,
    String? teacherId,
  ) => sl<SetStudentSubjectTeacherUseCase>()(studentId, subjectId, teacherId);

  /// Force-refetches just [boardClassId]'s subjects (so the newly
  /// backend-applied teacher discount is reflected) instead of wiping the
  /// entire catalog cache — every other board class's subjects, chapters,
  /// tests, and questions — for an unrelated change. Fire-and-forget: the
  /// sheet has already popped and confirmed the save; this only needs to
  /// land before the student next opens the chapters/home screen.
  void _refreshCatalogForBoardClass(WidgetRef ref, String? boardClassId) {
    if (boardClassId == null) return;
    ref
        .read(getSubjectsUseCaseProvider)(boardClassId, forceRefresh: true)
        .then((_) => ref.invalidate(enrolledSubjectsProvider));
  }
}

final assignTeacherViewModelProvider =
    NotifierProvider.autoDispose
        .family<AssignTeacherViewModel, AssignTeacherState, String?>(
          AssignTeacherViewModel.new,
        );
