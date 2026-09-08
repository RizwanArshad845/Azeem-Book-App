import '../../../core/network/result_guard.dart';
import '../../../core/storage/local_cache_service.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/repositories/student_repository.dart';
import '../../common/swr_repository_mixin.dart';
import '../datasources/remote/student_remote_datasource.dart';
import '../models/student_dto.dart';
import '../models/subject_enrollment_dto.dart';

class StudentRepositoryImpl with SwrRepositoryMixin implements StudentRepository {
  StudentRepositoryImpl({required this.remote, required this.cache});

  final StudentRemoteDataSource remote;

  @override
  final LocalCacheService cache;

  final Map<String, Student> _studentCache = {};
  final Map<String, List<Student>> _cachedStudentsByTeacher = {};

  @override
  Future<Result<Student>> completeOnboarding(Student student) {
    return guardRequest(() async {
      final dto = StudentDto.fromDomain(student);
      final saved = (await remote.completeOnboarding(dto)).toDomain();
      _studentCache[saved.id] = saved;
      return saved;
    });
  }

  @override
  Future<Result<List<Student>>> getStudentsForTeacher(String teacherId) {
    return fetchListWithSwr<Student>(
      cacheKey: 'cached_students_teacher_$teacherId',
      fromJson: (json) => StudentDto.fromJson(json).toDomain(),
      toJson: (student) => StudentDto.fromDomain(student).toJson(),
      // Roster changes are the whole reason a teacher checks this screen, so
      // keep the TTL short — background revalidation almost always fires,
      // but the student still gets an instant paint from the last fetch
      // instead of a blank/loading screen.
      ttl: const Duration(minutes: 15),
      fetchRemote: () async {
        final result = await guardRequest(
          () async => (await remote.getStudentsForTeacher(teacherId))
              .map((d) => d.toDomain())
              .toList(),
        );
        return result.when(
          success: Success.new,
          failure: (f) => f is NotFoundFailure
              ? const Success(<Student>[])
              : ResultFailure(f),
        );
      },
      getMemory: () => _cachedStudentsByTeacher[teacherId],
      setMemory: (value) => _cachedStudentsByTeacher[teacherId] = value,
    );
  }

  @override
  Future<Result<Student>> updateStudent(Student student) {
    return guardRequest(() async {
      final dto = StudentDto.fromDomain(student);
      final saved = (await remote.updateStudent(dto)).toDomain();
      _studentCache[saved.id] = saved;
      return saved;
    });
  }

  @override
  Future<Result<void>> deleteAccount(String studentId) {
    _studentCache.remove(studentId);
    return guardRequest(() => remote.deleteAccount(studentId));
  }

  @override
  Future<Result<Student?>> getStudentById(String studentId) {
    final cached = _studentCache[studentId];
    if (cached != null) {
      return Future.value(Success(cached));
    }
    return guardRequest(() async {
      final dto = await remote.getStudentById(studentId);
      final student = dto?.toDomain();
      if (student != null) {
        _studentCache[studentId] = student;
      }
      return student;
    });
  }

  @override
  Future<Result<List<SubjectEnrollment>>> updateSubjectEnrollments(
    String studentId,
    List<SubjectEnrollment> enrollments,
  ) {
    return guardRequest(() async {
      final dtos = enrollments.map(SubjectEnrollmentDto.fromDomain).toList();
      final saved = await remote.updateSubjectEnrollments(studentId, dtos);
      return saved.map((e) => e.toDomain()).toList();
    });
  }

  @override
  Future<Result<List<SubjectEnrollment>>> getSubjectEnrollments(
    String studentId,
  ) {
    return guardRequest(() async {
      final dtos = await remote.getSubjectEnrollments(studentId);
      return dtos.map((e) => e.toDomain()).toList();
    });
  }
}
