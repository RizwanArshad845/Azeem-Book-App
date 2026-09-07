import '../../../core/network/result_guard.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../../domain/student_onboarding/repositories/student_repository.dart';
import '../datasources/remote/student_remote_datasource.dart';
import '../models/student_dto.dart';
import '../models/subject_enrollment_dto.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({required this.remote});

  final StudentRemoteDataSource remote;

  @override
  Future<Result<Student>> completeOnboarding(Student student) {
    return guardRequest(() async {
      final dto = StudentDto.fromDomain(student);
      final saved = await remote.completeOnboarding(dto);
      return saved.toDomain();
    });
  }

  @override
  Future<Result<List<Student>>> getStudentsForTeacher(String teacherId) async {
    final result = await guardRequest(
      () async => (await remote.getStudentsForTeacher(teacherId))
          .map((d) => d.toDomain())
          .toList(),
    );
    return result.when(
      success: Success.new,
      failure: (f) =>
          f is NotFoundFailure ? const Success(<Student>[]) : ResultFailure(f),
    );
  }

  @override
  Future<Result<Student>> updateStudent(Student student) {
    return guardRequest(() async {
      final dto = StudentDto.fromDomain(student);
      final saved = await remote.updateStudent(dto);
      return saved.toDomain();
    });
  }

  @override
  Future<Result<void>> deleteAccount(String studentId) {
    return guardRequest(() => remote.deleteAccount(studentId));
  }

  @override
  Future<Result<Student?>> getStudentById(String studentId) {
    return guardRequest(() async {
      final dto = await remote.getStudentById(studentId);
      return dto?.toDomain();
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
