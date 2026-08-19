import '../../../../domain/auth/entities/user_role.dart';
import '../../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../models/teacher_dto.dart';

/// Same method signatures as [TeacherRemoteDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class TeacherDummyDataSource {
  Future<TeacherDto?> getTeacherByPhone(String phoneNumber);

  Future<TeacherDto> signUp(TeacherDto teacher);

  /// Persists a name/phone edit from `teacher-profile`. Campus/subjects/
  /// classes/approval-status/earnings fields are left untouched.
  Future<TeacherDto> updateTeacher(TeacherDto teacher);

  /// Soft-deletes (`isDeleted = true`) the in-memory record, if any.
  Future<void> deleteAccount(String teacherId);
}

/// In-memory Teacher store seeded with a handful of salesman-seeded,
/// already-approved Teacher records (§9.1: pre-seeded Teachers log in via
/// OTP only and skip signup entirely). Phone numbers below are valid per
/// `Validators.isValidPhone10Digits` (exactly 10 digits) so the OTP phone
/// entry screen accepts them unmodified.
class TeacherDummyDataSourceImpl implements TeacherDummyDataSource {
  TeacherDummyDataSourceImpl() {
    _seed();
  }

  static const _latency = Duration(milliseconds: 500);

  final List<TeacherDto> _teachers = [];

  @override
  Future<TeacherDto?> getTeacherByPhone(String phoneNumber) async {
    await Future.delayed(_latency);
    for (final teacher in _teachers) {
      if (teacher.phoneNumber == phoneNumber) return teacher;
    }
    return null;
  }

  @override
  Future<TeacherDto> signUp(TeacherDto teacher) async {
    await Future.delayed(_latency);
    _teachers.add(teacher);
    return teacher;
  }

  /// Merges the name/phone edit onto whatever's already recorded for this
  /// teacher (falls back to the incoming DTO as-is if no matching record is
  /// found, e.g. a salesman-seeded teacher not present in this in-memory
  /// list), stamping `updatedAt` like [signUp]'s callers would expect.
  @override
  Future<TeacherDto> updateTeacher(TeacherDto teacher) async {
    await Future.delayed(_latency);
    final index = _teachers.indexWhere((t) => t.id == teacher.id);
    final existing = index == -1 ? teacher : _teachers[index];
    final saved = existing.copyWith(
      name: teacher.name,
      phoneNumber: teacher.phoneNumber,
      updatedAt: DateTime.now(),
    );
    if (index == -1) {
      _teachers.add(saved);
    } else {
      _teachers[index] = saved;
    }
    return saved;
  }

  @override
  Future<void> deleteAccount(String teacherId) async {
    await Future.delayed(_latency);
    final index = _teachers.indexWhere((t) => t.id == teacherId);
    if (index != -1) {
      _teachers[index] = _teachers[index].copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );
    }
  }

  void _seed() {
    final now = DateTime.now();
    _teachers.addAll([
      TeacherDto(
        id: 'teacher-seed-001',
        name: 'Ahmed Raza',
        phoneNumber: '3001234567',
        role: UserRole.teacher,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 120)),
        updatedAt: now.subtract(const Duration(days: 10)),
        campusId: 'campus-001',
        subjects: const ['subj-pm-phy', 'subj-pm-chem'],
        classes: const ['bc-premed'],
        declaredStudentCount: 42,
        salesmanId: 'salesman-001',
        onboardingSource: TeacherOnboardingSource.salesmanSeeded,
        approvalStatus: TeacherApprovalStatus.approved,
        actualEarnings: 24500,
        projectedEarnings: 32000,
      ),
      TeacherDto(
        id: 'teacher-seed-002',
        name: 'Sana Fatima',
        phoneNumber: '3011234567',
        role: UserRole.teacher,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now.subtract(const Duration(days: 5)),
        campusId: 'campus-004',
        subjects: const ['subj-pe-math', 'subj-pe-cs'],
        classes: const ['bc-preeng'],
        declaredStudentCount: 30,
        salesmanId: 'salesman-002',
        onboardingSource: TeacherOnboardingSource.salesmanSeeded,
        approvalStatus: TeacherApprovalStatus.approved,
        actualEarnings: 18000,
        projectedEarnings: 21000,
      ),
      TeacherDto(
        id: 'teacher-seed-003',
        name: 'Bilal Hussain',
        phoneNumber: '3211234567',
        role: UserRole.teacher,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 2)),
        campusId: 'campus-007',
        subjects: const ['subj-pm-bio', 'subj-pm-eng'],
        classes: const ['bc-premed'],
        declaredStudentCount: 15,
        salesmanId: 'salesman-001',
        onboardingSource: TeacherOnboardingSource.salesmanSeeded,
        approvalStatus: TeacherApprovalStatus.approved,
        actualEarnings: 9000,
        projectedEarnings: null,
      ),
    ]);
  }
}
