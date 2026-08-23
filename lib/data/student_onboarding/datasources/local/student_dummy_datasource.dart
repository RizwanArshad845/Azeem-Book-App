import '../../../../domain/auth/entities/user_role.dart';
import '../../models/student_dto.dart';
import '../../models/subject_enrollment_dto.dart';

/// Same method signature as [StudentRemoteDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class StudentDummyDataSource {
  Future<StudentDto> completeOnboarding(StudentDto student);

  /// All students, filtered to those with a `subjectEnrollments` entry whose
  /// `teacherId` matches.
  Future<List<StudentDto>> getStudentsForTeacher(String teacherId);

  /// Persists a name/phone edit from `student-profile`. Campus/board-class/
  /// subject-enrollment fields are left untouched.
  Future<StudentDto> updateStudent(StudentDto student);

  /// Soft-deletes (`isDeleted = true`) the in-memory record, if any.
  Future<void> deleteAccount(String studentId);
}

/// In-memory backend with 15 pre-seeded mock students (11 paid bundle, 4 unpaid)
/// across campuses and classes for teacher portal testing.
class StudentDummyDataSourceImpl implements StudentDummyDataSource {
  StudentDummyDataSourceImpl() {
    _initMockStudents();
  }

  final Map<String, StudentDto> _students = {};

  void _initMockStudents() {
    final now = DateTime.now();
    final mockList = [
      // -----------------------------------------------------------------------
      // 11 STUDENTS WITH PAID BUNDLE (discountApplied: true)
      // -----------------------------------------------------------------------
      StudentDto(
        id: 'student-001',
        name: 'Ali Ahmed',
        phoneNumber: '+923001111111',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
        campusId: 'campus-001', // Punjab College Bahawalpur
        boardClassId: 'bc-11-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-001',
            subjectId: 'subj-11-phy',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-002',
        name: 'Fatima Zahra',
        phoneNumber: '+923002222222',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 18)),
        updatedAt: now,
        campusId: 'campus-004', // Punjab College Lahore
        boardClassId: 'bc-12-preeng',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-002',
            subjectId: 'subj-12-math',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-003',
        name: 'Hamza Tariq',
        phoneNumber: '+923003333333',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 16)),
        updatedAt: now,
        campusId: 'campus-007', // Punjab College Multan
        boardClassId: 'bc-11-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-003',
            subjectId: 'subj-11-chem',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-004',
        name: 'Usman Khalid',
        phoneNumber: '+923004444441',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
        campusId: 'campus-001', // Punjab College Bahawalpur
        boardClassId: 'bc-12-preeng',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-004',
            subjectId: 'subj-12-phy',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-005',
        name: 'Ayesha Noor',
        phoneNumber: '+923005555551',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now,
        campusId: 'campus-004', // Punjab College Lahore
        boardClassId: 'bc-11-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-005',
            subjectId: 'subj-11-bio',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-006',
        name: 'Hassan Raza',
        phoneNumber: '+923006666661',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now,
        campusId: 'campus-007', // Punjab College Multan
        boardClassId: 'bc-10',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-006',
            subjectId: 'subj-10-math',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-007',
        name: 'Maryam Bibi',
        phoneNumber: '+923007777771',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
        campusId: 'campus-002', // Superior College Bahawalpur
        boardClassId: 'bc-12-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-007',
            subjectId: 'subj-12-chem',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-008',
        name: 'Saad Abdullah',
        phoneNumber: '+923008888881',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now,
        campusId: 'campus-005', // Superior College Lahore
        boardClassId: 'bc-11-preeng',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-008',
            subjectId: 'subj-11-math',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-009',
        name: 'Khadija Farooq',
        phoneNumber: '+923009999991',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
        campusId: 'campus-008', // Superior College Multan
        boardClassId: 'bc-11-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-009',
            subjectId: 'subj-11-phy',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-010',
        name: 'Omar Farooq',
        phoneNumber: '+923001010101',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        campusId: 'campus-003', // Al-Hamd College Bahawalpur
        boardClassId: 'bc-12-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-010',
            subjectId: 'subj-12-bio',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),
      StudentDto(
        id: 'student-011',
        name: 'Zubair Khan',
        phoneNumber: '+923001112131',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now,
        campusId: 'campus-006', // Aspire College Lahore
        boardClassId: 'bc-9',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-011',
            subjectId: 'subj-9-math',
            teacherId: 'teacher-mock',
            discountApplied: true,
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // 4 UNPAID / FREE STUDENTS (discountApplied: false)
      // -----------------------------------------------------------------------
      StudentDto(
        id: 'student-012',
        name: 'Zainab Malik',
        phoneNumber: '+923004444444',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 9)),
        updatedAt: now,
        campusId: 'campus-002', // Superior College Bahawalpur
        boardClassId: 'bc-11-preeng',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-012',
            subjectId: 'subj-11-phy',
            teacherId: 'teacher-mock',
            discountApplied: false,
          ),
        ],
      ),
      StudentDto(
        id: 'student-013',
        name: 'Bilal Hassan',
        phoneNumber: '+923005555555',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now,
        campusId: 'campus-005', // Superior College Lahore
        boardClassId: 'bc-12-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-013',
            subjectId: 'subj-12-bio',
            teacherId: 'teacher-mock',
            discountApplied: false,
          ),
        ],
      ),
      StudentDto(
        id: 'student-014',
        name: 'Noor ul Ain',
        phoneNumber: '+923006666666',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
        campusId: 'campus-007', // Punjab College Multan
        boardClassId: 'bc-10',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-014',
            subjectId: 'subj-10-phy',
            teacherId: 'teacher-mock',
            discountApplied: false,
          ),
        ],
      ),
      StudentDto(
        id: 'student-015',
        name: 'Danish Ali',
        phoneNumber: '+923007777777',
        role: UserRole.student,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
        campusId: 'campus-004', // Punjab College Lahore
        boardClassId: 'bc-11-premed',
        subjectEnrollments: [
          SubjectEnrollmentDto(
            studentId: 'student-015',
            subjectId: 'subj-11-chem',
            teacherId: 'teacher-mock',
            discountApplied: false,
          ),
        ],
      ),
    ];

    for (final s in mockList) {
      _students[s.id] = s;
    }
  }

  @override
  Future<StudentDto> completeOnboarding(StudentDto student) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final saved = student.copyWith(updatedAt: DateTime.now());
    _students[saved.id] = saved;
    return saved;
  }

  @override
  Future<List<StudentDto>> getStudentsForTeacher(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Dynamically bind to the active teacher session so all 15 mock students
    // are immediately available for testing
    return _students.values.map((s) {
      final enrollments = s.subjectEnrollments?.map((e) {
        return e.copyWith(teacherId: teacherId);
      }).toList();
      return s.copyWith(subjectEnrollments: enrollments);
    }).toList();
  }

  @override
  Future<StudentDto> updateStudent(StudentDto student) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _students[student.id] ?? student;
    final saved = existing.copyWith(
      name: student.name,
      phoneNumber: student.phoneNumber,
      updatedAt: DateTime.now(),
    );
    _students[saved.id] = saved;
    return saved;
  }

  @override
  Future<void> deleteAccount(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final existing = _students[studentId];
    if (existing != null) {
      _students[studentId] = existing.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );
    }
  }
}
