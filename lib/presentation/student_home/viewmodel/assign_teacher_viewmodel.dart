import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/usecases/update_student_subject_enrollments_usecase.dart';
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

    final currentEnrollments =
        student.subjectEnrollments ?? <SubjectEnrollment>[];
    final updatedEnrollments = <SubjectEnrollment>[];
    var found = false;

    for (final enrollment in currentEnrollments) {
      if (enrollment.subjectId == subjectId) {
        found = true;
        updatedEnrollments.add(
          enrollment.copyWith(
            teacherId: state.selectedTeacherId,
            discountApplied: state.selectedTeacherId != null,
          ),
        );
      } else {
        updatedEnrollments.add(enrollment);
      }
    }

    if (!found) {
      updatedEnrollments.add(
        SubjectEnrollment.create(
          studentId: student.id,
          subjectId: subjectId,
          teacherId: state.selectedTeacherId,
          discountApplied: state.selectedTeacherId != null,
        ),
      );
    }

    final result = await sl<UpdateStudentSubjectEnrollmentsUseCase>()(
      student.id,
      updatedEnrollments,
    );

    if (!context.mounted) return;
    state = state.copyWith(isSaving: false);

    result.when(
      success: (savedEnrollments) {
        ref.read(studentOnboardingViewModelProvider.notifier).setStudent(
              student.copyWith(subjectEnrollments: savedEnrollments),
            );
        Navigator.of(context).pop();
        AppSnackbar.show(
          context,
          state.selectedTeacherId != null
              ? context.l10n.assignTeacherSavedSuccess
              : context.l10n.assignTeacherSetSelfStudy,
        );
      },
      failure: (failure) {
        AppSnackbar.show(
          context,
          failure.message.isNotEmpty
              ? failure.message
              : context.l10n.commonErrorGeneric,
        );
      },
    );
  }
}

final assignTeacherViewModelProvider =
    NotifierProvider.autoDispose
        .family<AssignTeacherViewModel, AssignTeacherState, String?>(
          AssignTeacherViewModel.new,
        );
