import '../../models/teacher_option_dto.dart';

/// THROWAWAY stand-in datasource — see the doc comment on the
/// `TeacherOption` domain entity
/// (`lib/domain/student_onboarding/entities/teacher_option.dart`) for why
/// this hardcoded set exists instead of reading the real `teacher-onboarding`
/// feature's `Teacher` list. Replace once both features exist; that
/// reconciliation is explicitly out of scope for this unit.
abstract class TeacherDirectoryDummyDataSource {
  Future<List<TeacherOptionDto>> getTeachersForCampus(String campusId);
}

/// Small hardcoded set of sample teachers spread across a few real campuses/
/// subjects, since there's no real "teachers by campus" endpoint yet (see
/// the class doc comment above).
class TeacherDirectoryDummyDataSourceImpl
    implements TeacherDirectoryDummyDataSource {
  static const List<TeacherOptionDto> _teachers = [
    TeacherOptionDto(
      id: 'teacher-opt-1',
      name: 'Sir Ahmed Raza',
      campusId: 'campus-001', // Punjab College Bahawalpur Campus
      subjectIds: ['subj-pm-phy', 'subj-pe-phy'],
    ),
    TeacherOptionDto(
      id: 'teacher-opt-2',
      name: 'Miss Sana Tariq',
      campusId: 'campus-001', // Punjab College Bahawalpur Campus
      subjectIds: ['subj-pm-chem', 'subj-pe-chem'],
    ),
    TeacherOptionDto(
      id: 'teacher-opt-3',
      name: 'Sir Bilal Hussain',
      campusId: 'campus-004', // Punjab College Lahore Campus
      subjectIds: ['subj-pe-math', 'subj-pe-cs'],
    ),
    TeacherOptionDto(
      id: 'teacher-opt-4',
      name: 'Miss Ayesha Khan',
      campusId: 'campus-004', // Punjab College Lahore Campus
      subjectIds: ['subj-pm-bio', 'subj-pm-eng'],
    ),
    TeacherOptionDto(
      id: 'teacher-opt-5',
      name: 'Sir Usman Farooq',
      campusId: 'campus-007', // Punjab College Multan Campus
      subjectIds: ['subj-pm-phy', 'subj-pm-chem'],
    ),
    TeacherOptionDto(
      id: 'teacher-opt-6',
      name: 'Miss Hira Malik',
      campusId: 'campus-002', // Superior College Bahawalpur Campus
      subjectIds: ['subj-pe-cs', 'subj-pm-eng'],
    ),
  ];

  @override
  Future<List<TeacherOptionDto>> getTeachersForCampus(String campusId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _teachers.where((t) => t.campusId == campusId).toList();
  }
}
