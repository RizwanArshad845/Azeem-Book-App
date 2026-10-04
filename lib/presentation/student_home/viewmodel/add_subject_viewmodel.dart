import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_onboarding/usecases/add_student_subject_enrollment_usecase.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import 'student_home_viewmodel.dart';

/// Subjects in the student's own board class that they haven't added yet —
/// what the Home "Add subject" sheet offers. Empty when the student has no
/// board class (the backend rejects enrolment without one) or has already
/// added everything.
final addableSubjectsProvider = FutureProvider<List<Subject>>((ref) async {
  final student = ref.watch(currentStudentProvider);
  final boardClassId = student?.boardClassId;
  if (student == null || boardClassId == null || boardClassId.isEmpty) {
    return const <Subject>[];
  }

  final all = await ref.watch(subjectsForBoardClassProvider(boardClassId).future);
  final enrolledIds = (student.subjectEnrollments ?? const [])
      .map((e) => e.subjectId)
      .toSet();
  return all.where((s) => !enrolledIds.contains(s.id)).toList();
});

/// Adds one subject to an already-onboarded student via
/// `POST /students/{id}/subject-enrollments` (teacher is optional and set
/// later from the subject's chapter list). `state` is the id of the subject
/// currently being added (`null` when idle) so the sheet can show a spinner
/// on just that row and block double taps.
class AddSubjectViewModel extends Notifier<String?> {
  @override
  String? build() => null;

  /// Returns `null` on success, or the [Failure] to show.
  Future<Failure?> add(String subjectId) async {
    if (state != null) return null; // an add is already in flight
    final student = ref.read(currentStudentProvider);
    if (student == null) return const UnknownFailure();

    state = subjectId;
    final result = await sl<AddStudentSubjectEnrollmentUseCase>()(
      student.id,
      subjectId,
    );
    state = null;

    return result.when(
      success: (saved) {
        final existing = student.subjectEnrollments ?? const [];
        ref.read(studentOnboardingViewModelProvider.notifier).setStudent(
              student.copyWith(
                subjectEnrollments: [
                  for (final e in existing)
                    if (e.subjectId != subjectId) e,
                  saved.copyWith(studentId: student.id),
                ],
              ),
            );
        // Home's subject list and the cart both derive from the student /
        // enrollments, so refresh what doesn't watch the student directly.
        ref.invalidate(studentCartViewModelProvider);
        return null;
      },
      failure: (failure) => failure,
    );
  }
}

final addSubjectViewModelProvider =
    NotifierProvider.autoDispose<AddSubjectViewModel, String?>(
      AddSubjectViewModel.new,
    );
