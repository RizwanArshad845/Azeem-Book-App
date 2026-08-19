import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/repositories/student_repository.dart';
import '../datasources/local/student_dummy_datasource.dart';
import '../datasources/remote/student_remote_datasource.dart';
import '../models/student_dto.dart';

/// Switches between the dummy and remote datasource per
/// `AppConfig.isMockMode` (§6.1/§6.2) — never called with a live endpoint
/// directly from a viewmodel.
class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({
    required this.remote,
    required this.dummy,
    required this.isMockMode,
  });

  final StudentRemoteDataSource remote;
  final StudentDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<Student>> completeOnboarding(Student student) async {
    try {
      final dto = StudentDto.fromDomain(student);
      final saved = isMockMode
          ? await dummy.completeOnboarding(dto)
          : await remote.completeOnboarding(dto);
      return Success(saved.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Student>>> getStudentsForTeacher(String teacherId) async {
    try {
      final dtos = isMockMode
          ? await dummy.getStudentsForTeacher(teacherId)
          : await remote.getStudentsForTeacher(teacherId);
      return Success(dtos.map((d) => d.toDomain()).toList());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Student>> updateStudent(Student student) async {
    try {
      final dto = StudentDto.fromDomain(student);
      final saved = isMockMode
          ? await dummy.updateStudent(dto)
          : await remote.updateStudent(dto);
      return Success(saved.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteAccount(String studentId) async {
    try {
      if (isMockMode) {
        await dummy.deleteAccount(studentId);
      } else {
        await remote.deleteAccount(studentId);
      }
      return const Success(null);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
