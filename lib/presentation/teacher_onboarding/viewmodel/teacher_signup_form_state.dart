import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/campus_directory/entities/campus.dart';

/// Immutable form state for the multi-step teacher onboarding wizard.
class TeacherFormState {
  const TeacherFormState({
    this.currentStep = 1,
    this.name = '',
    this.campus,
    this.studentCount = 0,
    this.selectedClassIds = const {},
    this.selectedSubjectIds = const {},
    this.nameError,
    this.campusError,
    this.classesError,
    this.subjectsError,
  });

  final int currentStep;
  final String name;
  final Campus? campus;
  final int studentCount;
  final Set<String> selectedClassIds;
  final Set<String> selectedSubjectIds;
  final String? nameError;
  final String? campusError;
  final String? classesError;
  final String? subjectsError;

  TeacherFormState copyWith({
    int? currentStep,
    String? name,
    Campus? campus,
    int? studentCount,
    Set<String>? selectedClassIds,
    Set<String>? selectedSubjectIds,
    String? nameError,
    String? campusError,
    String? classesError,
    String? subjectsError,
    bool clearCampusError = false,
    bool clearClassesError = false,
    bool clearSubjectsError = false,
  }) {
    return TeacherFormState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      campus: campus ?? this.campus,
      studentCount: studentCount ?? this.studentCount,
      selectedClassIds: selectedClassIds ?? this.selectedClassIds,
      selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
      nameError: nameError ?? this.nameError,
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
    required String requiredCampusMsg,
  }) {
    final nameValid = state.name.trim().isNotEmpty;
    final campusValid = state.campus != null;
    state = state.copyWith(
      nameError: nameValid ? null : requiredNameMsg,
      campusError: campusValid ? null : requiredCampusMsg,
    );
    return nameValid && campusValid;
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
