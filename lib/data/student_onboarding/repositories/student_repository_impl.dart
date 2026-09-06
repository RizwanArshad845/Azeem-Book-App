import '../../../core/network/result_guard.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/repositories/student_repository.dart';
import '../datasources/remote/student_remote_datasource.dart';
import '../models/student_dto.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({required this.remote});

  final StudentRemoteDataSource remote;
  final Map<String, Student> _studentCache = {};

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
}
