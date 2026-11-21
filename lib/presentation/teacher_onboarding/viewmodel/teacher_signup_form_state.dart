import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/campus_directory/entities/campus.dart';

/// Immutable form state for the multi-step teacher onboarding wizard.
class TeacherFormState {
  const TeacherFormState({
    this.currentStep = 1,
    this.name = '',
    this.phoneNumber = '',
    this.campus,
    this.studentCount = 0,
    this.selectedClassIds = const {},
    this.selectedSubjectIds = const {},
    this.nameError,
    this.phoneError,
    this.campusError,
    this.classesError,
    this.subjectsError,
  });

  final int currentStep;
  final String name;
  final String phoneNumber;
  final Campus? campus;
  final int studentCount;
  final Set<String> selectedClassIds;
  final Set<String> selectedSubjectIds;
  final String? nameError;
  final String? phoneError;
  final String? campusError;
  final String? classesError;
  final String? subjectsError;

  /// Non-mutating "would this pass `validateStep1`" check, used to reactively
  /// grey out the step-1 Next button (CLAUDE.md: "Submit buttons: Greyed out
  /// / disabled until all mandatory fields pass validation") without setting
  /// error text just from watching — [TeacherFormNotifier.validateStep1] is
  /// the state-mutating, error-setting counterpart used on tap.
  bool get isStep1Valid =>
      name.trim().isNotEmpty &&
      Validators.isValidPhoneLocal(phoneNumber.trim()) &&
      campus != null;

  /// Non-mutating "would this pass `validateStep2`" check — see [isStep1Valid].
  bool get isStep2Valid =>
      selectedClassIds.isNotEmpty && selectedSubjectIds.isNotEmpty;

  TeacherFormState copyWith({
    int? currentStep,
    String? name,
    String? phoneNumber,
    Campus? campus,
    int? studentCount,
    Set<String>? selectedClassIds,
    Set<String>? selectedSubjectIds,
    String? nameError,
    String? phoneError,
    String? campusError,
    String? classesError,
    String? subjectsError,
    bool clearPhoneError = false,
    bool clearCampusError = false,
    bool clearClassesError = false,
    bool clearSubjectsError = false,
  }) {
    return TeacherFormState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      campus: campus ?? this.campus,
      studentCount: studentCount ?? this.studentCount,
      selectedClassIds: selectedClassIds ?? this.selectedClassIds,
      selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
      nameError: nameError ?? this.nameError,
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      campusError: clearCampusError ? null : (campusError ?? this.campusError),
      classesError: clearClassesError ? null : (classesError ?? this.classesError),
      subjectsError: clearSubjectsError ? null : (subjectsError ?? this.subjectsError),
    );
  }
}

/// Riverpod state notifier managing form state without any [StatefulWidget]/`setState`.
class TeacherFormNotifier extends Notifier<TeacherFormState> {
  @override
  TeacherFormState build() => const TeacherFormState();

  void updateName(String name) {
    state = state.copyWith(name: name, nameError: null);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber, clearPhoneError: true);
  }

  void updateCampus(Campus? campus) {
    state = state.copyWith(campus: campus, clearCampusError: true);
  }

  void updateStudentCount(int count) {
    state = state.copyWith(studentCount: count);
  }

  void updateClasses(Set<String> classIds) {
    state = state.copyWith(
      selectedClassIds: classIds,
      selectedSubjectIds: const {},
      clearClassesError: true,
      clearSubjectsError: true,
    );
  }

  void updateSubjects(Set<String> subjectIds) {
    state = state.copyWith(
      selectedSubjectIds: subjectIds,
      clearSubjectsError: true,
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  bool validateStep1({
    required String requiredNameMsg,
    required String invalidPhoneMsg,
    required String requiredCampusMsg,
  }) {
    final nameValid = state.name.trim().isNotEmpty;
    final phoneValid = Validators.isValidPhoneLocal(state.phoneNumber.trim());
    final campusValid = state.campus != null;
    state = state.copyWith(
      nameError: nameValid ? null : requiredNameMsg,
      phoneError: phoneValid ? null : invalidPhoneMsg,
      clearPhoneError: phoneValid,
      campusError: campusValid ? null : requiredCampusMsg,
    );
    return nameValid && phoneValid && campusValid;
  }

  bool validateStep2({
    required String requiredClassesMsg,
    required String requiredSubjectsMsg,
  }) {
    final classesValid = state.selectedClassIds.isNotEmpty;
    final subjectsValid = state.selectedSubjectIds.isNotEmpty;
    state = state.copyWith(
      classesError: classesValid ? null : requiredClassesMsg,
      subjectsError: subjectsValid ? null : requiredSubjectsMsg,
    );
    return classesValid && subjectsValid;
  }
}

final teacherFormNotifierProvider =
    NotifierProvider.autoDispose<TeacherFormNotifier, TeacherFormState>(
  TeacherFormNotifier.new,
);
